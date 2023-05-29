class AddOtpToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :otp, :integer,default: 0
  end
end
