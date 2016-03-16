module Fog
  module AWS
    class SES
      class Base
        attr_reader :settings

        def initialize(settings = {})
          @settings = settings
        end

        def deliver!(mail)
          ses = Fog::AWS::SES.new(settings)
          ses.send_raw_email(mail).tap do |response|
            message = create_message! mail, response
            mail.message_id = "#{message.uuid}@email.amazonses.com"
          end
        end

        private

        def create_message!(mail, response)
          Message.create!(
            uuid: response.body['MessageId'],
            token: mail.instance_variable_get(:@_token),
            campaign_id: mail.instance_variable_get(:@_campaign_id),
            subscriber_id: mail.instance_variable_get(:@_subscriber_id),
            sent_at: Time.now
          )
        end
      end
    end
  end
end
