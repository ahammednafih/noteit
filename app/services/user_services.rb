module Services
  class UserServices
    def self.email_activate(user)
      user.email_confirmed = true
      user.confirm_token = nil
      user.save!
    end
  
    def self.send_password_reset(user)
      generate_token(user,:reset_password_token)
      user.reset_password_sent_at = Time.zone.now
      user.save!
      Mailers::UserMailer.delay.deliver_forgot_password(user)
    end
    # This generates a random password reset token for the user
    def self.generate_token(user, column)
      begin
        user[column] = SecureRandom.base64.gsub('/"', '_').to_s
      end while User.exists?(column => user[column])
    end
  end
end
