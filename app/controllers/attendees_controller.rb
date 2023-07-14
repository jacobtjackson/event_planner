class AttendeesController < ApplicationController
    before_action :set_attendee

    rescue_from ActiveRecord::RecordNotFound do
        render json: { error: "We weren't able to find your account. Please try again or RSVP to an event." }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do
        render json: { error_msg: 'There was a problem while updating your account. Please try again.', errors: @event.errors }, status: :unprocessable_entity
    end

    def show
        @attendee = Attendee.includes(:events).find_by_email_address params[:email_address]

        render json: AttendeesBlueprint.render(@attendee, view: :with_events), status: :ok
    end

    def update
        @attendee.update(attendee_params)

        render json: { message: 'You successfully updated your account!' }, status: :ok
    end

    def destroy
        @attendee.destroy!

        head :no_content
    end

    private

    def set_attendee
        @attendee = Attendee.find_by_email_address params[:email_address]
    end

    def attendee_params
        params.require(:attendee).permit(:email_address, :first_name, :last_name)
    end
end
