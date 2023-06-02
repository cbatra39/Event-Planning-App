class Admin::Auth::PasswordsController < ApplicationController

    def new
    end

    def passwordreset
        User.send_reset_password_instructions(forgot_params)
        redirect_to admin_login_path, flash: { notice:"You will recieve an email if you have account with us"}
    end


    def forgot_params
        params.permit(:email)
    end
        
end
