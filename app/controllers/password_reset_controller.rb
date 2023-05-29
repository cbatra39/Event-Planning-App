class PasswordResetController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :verify_sign_in , only: [:send_otp, :verify_otp, :reset_password]
  
      def send_otp
          user = User.find_by(email: params[:email])
          if user
            otp = generate_otp
            user.update(otp:otp)
            user.save!
        
            UserMailer.otp_email(user, otp).deliver_now
        
            render json: { message: "OTP sent successfully" }, status: :ok
          else
            render json: { error: "User not found" }, status: :not_found
          end
        end
        
        def verify_otp
          user = User.find_by(otp: params[:otp])
          if user
            user.update(otp_verified: true)
            render json: { message: "OTP verified successfully" }, status: :ok
          else
            render json: { error: "Invalid OTP" }, status: :unprocessable_entity
          end
        end
    
        def reset_password
          user = User.find_by(otp_verified: true)
          if user
            if params[:password] != params[:password_confirmation]
              render json: { error: "Password and password confirmation do not match" }, status: :unprocessable_entity
            elsif user.otp_verified? # Check if OTP is verified
              if user.update(password: params[:password], password_confirmation: params[:password_confirmation],otp_verified: false)
                
                render json: { message: "Password updated successfully" }, status: :ok
              else
                render json: { error: user.errors.full_messages }, status: :unprocessable_entity
              end
            else
              render json: { error: "OTP not verified" }, status: :unprocessable_entity
            end
          else
            render json: { error: "Invalid user" }, status: :unprocessable_entity
          end
        end
    private
  
    def verify_sign_in
      user = current_user
      if user
        render json: { error: "Action not allowed for signed-in users" }, status: :unprocessable_entity
      end
    end
     
    def generate_otp
      SecureRandom.random_number(1000..9999)
    end  
    end
    