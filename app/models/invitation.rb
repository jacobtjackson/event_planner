class Invitation < ApplicationRecord
    belongs_to :attendee
    belongs_to :event

    enum invitation_status: %i[no_response accepted declined]
end
