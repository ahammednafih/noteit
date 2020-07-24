# frozen_string_literal: true
require 'bcrypt'
require 'securerandom'

class User < ActiveRecord::Base
  before_create :confirmation_token

  has_many :notices
  
  validates_presence_of :email, :name
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => /\A[^@,\s]+@[^@,\s]+\.[^@,\s]+\z/
  validates_format_of :name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/
  validates_confirmation_of :password
  validates_presence_of :password_digest

  def password
    @password
  end

  def password=(plaintxt_pass)
    self.password_digest = BCrypt::Password.create(plaintxt_pass)
  end
  def authenticate(plaintxt_pass)
    if BCrypt::Password.new(self.password_digest) == plaintxt_pass
       true
    end
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!
  end

  def send_password_reset
    generate_token(:reset_password_token)
    self.reset_password_sent_at = Time.zone.now
    save!
    UserMailer.deliver_forgot_password(self)# This sends an e-mail with a link for the user to reset the password
  end
  # This generates a random password reset token for the user
  def generate_token(column)
    begin
      self[column] = SecureRandom.base64.to_s
    end while User.exists?(column => self[column])
  end
  
  private
    def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = SecureRandom.base64.to_s
      end
    end
end
