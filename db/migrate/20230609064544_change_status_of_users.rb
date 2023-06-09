class ChangeStatusOfUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :status
  end
end
