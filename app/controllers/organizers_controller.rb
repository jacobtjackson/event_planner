class OrganizersController < ApplicationController
    before_action :set_organizer, except: :show
    rescue_from ActiveRecord::RecordNotFound do
        render json: { error: "We weren't able to find your account. Please try again or create an event." }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do
        render json: { error_msg: 'There was a problem while updating your account. Please try again.', errors: @event.errors }, status: :unprocessable_entity
    end

    def show
        @organizer = Organizer.includes(:events).find_by_email_address! params[:email_address]
        render json: OrganizersBlueprint.render(@organizer, view: :with_events), status: :ok
    end

    def update
        @organizer.update!(organizer_params)

        render json: { message: 'You successfully updated your account!' }, status: :ok
    end

    def destroy
        @organizer.destroy!

        head :no_content
    end

    private

    def set_organizer
        @organizer = Organizer.find_by_email_address! params[:email_address]
    end

    def organizer_params
        params.require(:organizer).permit(:first_name, :last_name, :email_address)
    end
end
