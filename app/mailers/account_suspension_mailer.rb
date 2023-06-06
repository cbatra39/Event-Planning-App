class AccountSuspensionMailer < ApplicationMailer
    def suspended(user)
        @user = user
        mail(to: @user.email, subject: 'Account Suspended')
    end
    def deleted(user)
        @user = user
        mail(to: @user.email, subject: 'Account Deleted')
    end
end
