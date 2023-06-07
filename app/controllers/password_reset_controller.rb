class PasswordResetController < ApplicationController
    include Responses
    skip_before_action :verify_authenticity_token
    before_action :verify_sign_in , only: [:send_otp, :verify_otp, :reset_password]
   
    def send_otp
      user = User.find_by(email: params[:email])
      if user
        otp = generate_otp
        user.update(otp: otp, otp_generated_at: Time.now)
        user.save!
        UserMailer.otp_email(user, otp).deliver_now
        success("OTP sent successfully")
      else
        error_404("User not found")
      end
    end
    

    
    def verify_otp
      user = User.find_by(email: params[:email], otp: params[:otp])
      if user
        if user.otp_generated_at && (Time.now - user.otp_generated_at) > 3.minutes
          user.update(otp: 0)
          error("OTP has expired. Please request a new OTP.")
        else
          user.update(otp_verified: true)
          success("OTP verified successfully")
        end
      else
        error_401("please enter correct email or otp")
      end
    end
    

        def reset_password
          user = User.find_by(email: params[:email], otp_verified: true)
          if user
            if params[:password] != params[:password_confirmation]
              error("Password and password confirmation do not match")
            elsif user.otp_verified?
              if user.update(password: params[:password], password_confirmation: params[:password_confirmation],otp_verified: false,otp:0) 
                success("Password updated successfully" )
              else
                error( user.errors.full_messages )
              end
            else
              error( "OTP not verified" )
            end
          else
            error("Invalid user" )
          end
        end


    private
  
    def verify_sign_in
      user = current_user
      if user
        error("Action not allowed for signed-in users")
      end
    end
     
    def generate_otp
      SecureRandom.random_number(1000..9999)
    end  
    end
    