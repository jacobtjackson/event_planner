class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.text :description, null: false
      t.integer :event_type, default: 0, null: false
      t.boolean :private, default: false, null: false
      t.string :title, default: '', limit: 75
      t.text :location, default: ''

      t.references :organizer
      t.timestamps
    end
  end
end
