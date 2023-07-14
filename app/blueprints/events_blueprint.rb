class EventsBlueprint < Blueprinter::Base
    identifier :id
    fields :title, :description, :start_time, :end_time, :event_type, :private

    view :with_associations do
        association :invitations, blueprint: InvitationsBlueprint, view: :with_attendee
        association :organizer, blueprint: OrganizersBlueprint
    end
end