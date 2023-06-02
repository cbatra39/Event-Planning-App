class CreateEventCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :event_categories do |t|
      t.string :event_category
      t.boolean :status

      t.timestamps
    end
  end
end
