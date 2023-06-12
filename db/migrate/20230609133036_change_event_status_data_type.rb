class ChangeEventStatusDataType < ActiveRecord::Migration[7.0]
  def change
    remove_column :events,:event_status
    add_column :events, :event_status, :integer
  end
end
