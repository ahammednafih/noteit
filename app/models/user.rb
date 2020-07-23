# frozen_string_literal: true
require 'bcrypt'
require 'securerandom'

class User < ActiveRecord::Base
  before_create :confirmation_token

  validates_presence_of :email, :name
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => /\A[^@,\s]+@[^@,\s]+\.[^@,\s]+\z/
  validates_format_of :name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/

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
  
  private
    def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = SecureRandom.base64.to_s
      end
    end
end
