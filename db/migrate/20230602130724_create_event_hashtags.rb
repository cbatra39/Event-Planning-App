class CreateEventHashtags < ActiveRecord::Migration[7.0]
  def change
    create_table :event_hashtags do |t|
      t.references :event, null: false, foreign_key: true
      t.references :hashtag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
