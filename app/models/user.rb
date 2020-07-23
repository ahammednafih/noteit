# frozen_string_literal: true
require 'bcrypt'

class User < ActiveRecord::Base

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
  
  validates_presence_of :email, :name
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => /\A[^@,\s]+@[^@,\s]+\.[^@,\s]+\z/
  validates_format_of :name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/

end
