module Services
  class UserServices
    def self.generate_token
      require 'securerandom'  
      SecureRandom.base64.gsub('/', '_').to_s
    end  
  end
end
