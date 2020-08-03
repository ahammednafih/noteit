# frozen_string_literal: true
require 'bcrypt'

class User < ActiveRecord::Base
  attr_reader :password
  
  has_many :notes
  mount_uploader :avatar, AvatarUploader
  
  validates_presence_of :email, :user_name
  validates_uniqueness_of :email, :user_name, :case_sensitive => false
  validates_format_of :email, :with => /\A[^@,\s]+@[^@,\s]+\.[^@,\s]+\z/
  validates_format_of :user_name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/
  validates_format_of :first_name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/, :allow_blank => true
  validates_format_of :last_name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/, :allow_blank => true
  validates_confirmation_of :password
  validates_presence_of :password_digest

  before_create :set_confirmation_token
  before_save :set_full_name
  after_update :send_reset_token, :if => :reset_password_token_changed?
  after_create :send_confirmation_token

  def set_full_name                                                                                                                                                                                    
    self.full_name = "#{self.first_name} #{self.last_name}"
  end

  def password=(plaintxt_pass)
    @password = plaintxt_pass
    self.password_digest = BCrypt::Password.create(@password)
  end

  def password_confirmation=(plaintxt_pass)
    @password_confirmation = plaintxt_pass
  end

  def authenticate(plaintxt_pass)
    if (BCrypt::Password.new(self.password_digest) == plaintxt_pass) && (self.email_confirmed)
       true
    end
  end

  def set_reset_token
    reset_password_token = Services::UserServices.generate_token
    reset_password_sent_at = Time.now.utc
    self.update_attributes(:reset_password_token => reset_password_token, :reset_password_sent_at => reset_password_sent_at)
  end

  def set_email_confirmed
    email_confirmed = true
    confirm_token = nil
    self.update_attributes(:email_confirmed => email_confirmed, :confirm_token => confirm_token)
  end
  private
    def set_confirmation_token
      unless self.confirm_token.present?
          self.confirm_token = Services::UserServices.generate_token
      end
    end

    def send_reset_token
      Mailers::UserMailer.delay.deliver_forgot_password(self)
    end

    def send_confirmation_token
      Mailers::UserMailer.delay.deliver_registration_confirmation(self)
    end
end
