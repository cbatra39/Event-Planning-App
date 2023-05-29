class UserMailer < ApplicationMailer
    def otp_email(user, otp)
      @user = user
      @otp = otp
      mail(to: @user.email, subject: 'OTP for Password Reset')
    end
  end
  