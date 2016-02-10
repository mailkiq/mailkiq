module SES
  class Base
    attr_reader :settings

    def initialize(settings = {})
      @settings = settings
    end

    def deliver!(mail)
      ses = Fog::AWS::SES.new(settings)
      ses.send_raw_email(mail).tap do |response|
        message = Message.find mail.message_id
        message.update uid: response.body['MessageId']
        mail.message_id = "#{message.uid}@email.amazonses.com"
      end
    end
  end
end
