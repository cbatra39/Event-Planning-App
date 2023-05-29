class AddOtpstatusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :otp_verified, :boolean,  default: false
    add_column :users, :status, :string,  default: "active"

  end
end
