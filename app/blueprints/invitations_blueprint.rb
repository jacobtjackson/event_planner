class InvitationsBlueprint < Blueprinter::Base
    identifier :id
    field :invitation_status

    view :with_event do
        association :event, blueprint: EventsBlueprint
    end

    view :with_attendee do
        association :attendee, blueprint: AttendeesBlueprint
    end

    view :all_associations do
        association :event, blueprint: EventsBlueprint
        association :attendee, blueprint: AttendeesBlueprint
    end
end