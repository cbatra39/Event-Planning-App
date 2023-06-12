class ChangeStatusDataTypeInUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :status
    add_column :users, :status, :integer
    add_column :users, :is_verified, :integer, default: 2
  end
end


