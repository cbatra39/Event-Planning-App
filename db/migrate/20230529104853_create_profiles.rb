class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles , force: :cascade do |t|
      t.string :first_name
      t.string :last_name
      t.date :dob
      t.string :phone_number
      t.string :address
      t.references :user, foreign_key: { to_table: :users }, index: true 
      t.timestamps
    end
    add_foreign_key :profiles, :users, on_delete: :cascade
  end
end
