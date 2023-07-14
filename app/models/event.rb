class Event < ApplicationRecord
    belongs_to :organizer, required: true
    has_many :invitations
    has_many :attendees, through: :invitations

    enum event_type: %i[virtual in_person]

    validates_presence_of :start_time, :end_time, :description, :event_type, :title
    validate :validate_timeframe

    private

    def validate_timeframe
        return if start_time.blank? || end_time.blank?

        errors.add(:end_date, 'cannot be before the start date') if end_time < start_time
    end
end
