class OrganizersBlueprint < Blueprinter::Base
    identifier :id
    fields :first_name, :last_name, :email_address

    view :with_events do
        association :events, blueprint: EventsBlueprint
    end
end