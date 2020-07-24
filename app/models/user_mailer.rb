class UserMailer < ActionMailer::Base
    def registration_confirmation(user)
        recipients    user.email
        from          "Note It Admin"
        subject       "Please complete the registration"
        sent_on       Time.now
        body          :user => user
    end

    def forgot_password(user)
        recipients    user.email
        from          "Note It Admin"
        subject       "Reset password"
        sent_on       Time.now
        body          :user => user
    end
end
