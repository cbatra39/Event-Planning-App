class AccountSuspensionMailer < ApplicationMailer
    def suspended(user)
        @user = user
        mail(to: @user.email, subject: 'Account Suspended')
    end
    def deleted(user)
        @user = user
        mail(to: @user.email, subject: 'Account Deleted')
    end
    def event_approved(user,event)
        @user = user
        @event = event
        mail(to: @user.email, subject: 'Your report is cancelled.')
    end
    def event_suspended(user,event)
        @user = user
        @event = event
        mail(to: @user.email, subject: 'Event Suspended')
    end
    def approved(user)
        @user = user
        mail(to: @user.email, subject: 'Account approved')
    end
end
