module SES
  class Base
    attr_reader :settings

    def initialize(settings = {})
      @settings = settings
    end

    def deliver!(mail)
      ses = Fog::AWS::SES.new(settings)
      response = ses.send_raw_email(mail)

      ahoy_message = Ahoy::Message.find mail.message_id
      ahoy_message.update message_id: response.body['MessageId']
      mail.message_id = "#{ahoy_message.message_id}@email.amazonses.com"

      response
    end
  end
end
