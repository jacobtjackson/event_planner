class CreateOrganizers < ActiveRecord::Migration[6.1]
  def change
    create_table :organizers do |t|
      t.string :email_address
      t.string :first_name
      t.string :last_name
      t.timestamps
    end

    add_foreign_key :events, :organizers, on_delete: :cascade
  end
end
