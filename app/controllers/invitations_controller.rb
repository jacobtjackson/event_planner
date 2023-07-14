class InvitationsController < ApplicationController
    before_action :set_invitation, only: %i[update destroy]

    rescue_from ActiveRecord::RecordNotFound do
        render json: { error: "We weren't able to find your invitation. Please try again." }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do
        render json: { error_msg: 'There was a problem while updating your RSVP. Please try again.', errors: @invitation.errors }, status: :unprocessable_entity
    end

    def show
        @invitation = Invitation.includes(:attendee, :event).find params[:id]

        render json: InvitationsBlueprint.render(@invitation, view: :all_associations), status: :ok
    end

    def create
        event = Event.find params[:event_id]
        if event.private?
            render json: { error_msg: "This is a private event and can only be RSVP'd to by people the organizer expressly invites." }, status: :unprocessable_entity
            return
        end

        attendee = Attendee.find_or_create_by(email_address: params[:attendee_email])
        @invitation = Invitation.where(attendee_id: attendee.id, event_id: params[:event_id]).first_or_initialize
        @invitation.invitation_status = params[:invitation_status]
        @invitation.save!

        render json: { message: "You have successfully RSVP'd to this event." }, status: :created
    end

    def update
        @invitation.update! invitation_status: params[:invitation_status]

        render json: { message: "You successfully RSVP'd to this event." }, status: :created
    end

    def destroy
        @invitation.destroy!

        head :no_content
    end

    private

    def set_invitation
        @invitation = Invitation.find params[:id]
    end
end
