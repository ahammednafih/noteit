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

  before_create :confirmation_token
  before_save :full_name

  def full_name                                                                                                                                                                                    
    self.full_name = ([self.first_name, self.last_name] - ['']).compact.join(' ')                         
  end

  def password=(plaintxt_pass)
    @password = plaintxt_pass
    self.password_digest = BCrypt::Password.create(@password)
  end

  def password_confirmation=(plaintxt_pass)
    @password_confirmation = plaintxt_pass
  end

  def authenticate(plaintxt_pass)
    if BCrypt::Password.new(self.password_digest) == plaintxt_pass
       true
    end
  end

  private
    def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = Services::UserServices.generate_token
      end
    end
end
