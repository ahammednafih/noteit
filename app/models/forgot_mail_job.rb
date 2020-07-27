class ForgotMailJob < Struct.new(:user)
    def before(job)
        puts "Starting the job at"
        puts Time.now.utc
    end
    def perform
        UserMailer.deliver_forgot_password(user)
    end
end