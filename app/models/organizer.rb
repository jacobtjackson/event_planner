class Organizer < ApplicationRecord
    has_many :events

    validates :email_address, format: { with: /\A[A-Za-z0-9+_.-]+@([A-Za-z0-9]+\.)+[A-Za-z]{2,6}\z/, message: 'Email invalid' },
                              uniqueness: { case_sensitive: false },
                              length: { minimum: 4, maximum: 75 }
end
