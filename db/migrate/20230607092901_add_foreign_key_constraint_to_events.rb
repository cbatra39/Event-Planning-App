class AddForeignKeyConstraintToEvents < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :events, :event_categories, column: :event_categories_id
    add_foreign_key :events, :event_categories, column: :event_categories_id , on_delete: :cascade
    remove_foreign_key :event_hashtags, :events, column: :event_id
    add_foreign_key :event_hashtags, :events, column: :event_id, on_delete: :cascade
  end


  def down
    remove_foreign_key :events, :event_categories, column: :event_categories_id
    add_foreign_key :events, :event_categories, column: :event_categories_id
    remove_foreign_key :event_hashtags, :events, column: :event_id
    add_foreign_key :event_hashtags, :events, column: :event_id
  end
end
