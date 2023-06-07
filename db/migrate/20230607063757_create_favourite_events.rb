# db/migrate/[timestamp]_create_favourite_events.rb
class CreateFavouriteEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :favourite_events do |t|
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true
     
      t.timestamps
    end
  end
end
