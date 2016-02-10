module AhoyEmail
  class Interceptor
    def self.delivering_email(message)
      AhoyEmail::Processor.new(message).track_send
    end
  end
end
