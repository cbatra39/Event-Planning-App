class AddColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users , :device_token , :string
    add_column :users , :device_type , :string

  end
end
