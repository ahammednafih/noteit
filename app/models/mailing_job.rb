class MailingJob < Struct.new(:user)
    def before(job)
        puts "Starting the job at"
        puts Time.now.utc
    end
    def perform
        UserMailer.deliver_registration_confirmation(user)
    end
end