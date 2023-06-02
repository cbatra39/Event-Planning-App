class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :location
      t.float :latitude
      t.float :longitude
      t.boolean :is_approved, :default => false
      t.string :event_status, :default => "active"
      t.date :start_date
      t.time :start_time
      t.date :end_date
      t.time :end_time
      t.references :user, null: false, foreign_key: true
      t.string :description
      t.references :event_categories, null: false, foreign_key: true

      t.timestamps
    end
  end
end
