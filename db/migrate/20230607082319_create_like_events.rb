class CreateLikeEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :like_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
