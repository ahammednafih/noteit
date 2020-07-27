class Notice < ActiveRecord::Base
  before_create :generate_public_token

  belongs_to :user

  private
    def generate_public_token
      if self.public
        self.public_token = SecureRandom.base64.to_s
      end
    end
end
