class EventsController < ApplicationController
    before_action :find_event, only: %i[update destroy update_invitations]

    rescue_from ActiveRecord::RecordNotFound do
        render json: { error: "We weren't able to find the event you requested. Please try again." }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do
        render json: { error_msg: 'There was a problem while creating your event. Please try again.', errors: @event.errors }, status: :unprocessable_entity
    end

    def index
        @events = Event.where(private: false)

        render json: EventsBlueprint.render(@events), status: :ok
    end

    def show
        @event = Event.includes(:organizer, :attendees).find params[:id]

        render json: EventsBlueprint.render(@event, view: :with_associations), status: :ok
    end

    def create
        @event = Event.new(event_params)
        @event.organizer_id = Organizer.find_or_create_by(email_address: params[:organizer_email]).id

        @event.save!

        attendees = params[:attendees]

        create_invitations(attendees)

        render json: EventsBlueprint.render(@event, view: :with_associations, root: :event, meta: { invalid_invitations: @invalid_invitations }), status: :created
    end

    def update
        @event.update(event_params)

        render json: { message: 'You successfully updated your event!' }, status: :ok
    end

    def destroy
        @event.destroy

        head :no_content
    end

    def update_invitations
        attendees = params[:attendees]

        create_invitations(attendees)

        render json: EventsBlueprint.render(@event, view: :with_associations, root: :event, meta: { invalid_invitations: @invalid_invitations }), status: :ok
    end

    private

    def find_event
        @event = Event.find params[:id]
    end

    def event_params
        params.require(:event).permit(:start_time, :end_time, :description, :event_type, :private, :title)
    end

    def create_invitations(attendees)
        @invalid_invitations = []
        @valid_invitations = []
        unless attendees.blank?
            attendees.each do |a|
                attendee = Attendee.find_or_create_by(email_address: a)
                invitation = Invitation.new(event_id: @event.id, attendee_id: attendee.id)
                invitation.valid? ? @valid_invitations << invitation : @invalid_invitations << a
            end
        end
        Invitation.transaction do
            @valid_invitations.map(&:save!)
        end
    end
end
