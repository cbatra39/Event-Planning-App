class AddForeignKeyConstraintToProfiles < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :profiles, :users
    add_foreign_key :profiles, :users, on_delete: :cascade
  end

  def down
    remove_foreign_key :profiles, :users
    add_foreign_key :profiles, :users
  end
end
