class CreateInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :invitations do |t|
      t.references :attendee, foreign_key: { on_delete: :cascade }
      t.references :event, foreign_key: { on_delete: :cascade }
      t.integer :invitation_status, default: 0, null: false

      t.timestamps
    end
  end
end
