module SES
  class Base
    attr_reader :settings

    def initialize(settings = {})
      @settings = settings
    end

    def deliver!(mail)
      ses = Fog::AWS::SES.new(settings)
      response = ses.send_raw_email(mail)

      ahoy_message = Message.find mail.message_id
      ahoy_message.update uid: response.body['MessageId']
      mail.message_id = "#{ahoy_message.uid}@email.amazonses.com"

      response
    end
  end
end
