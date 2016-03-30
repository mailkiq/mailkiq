module Aws
  module Rails
    class Mailer
      attr_reader :settings

      def initialize(settings = {})
        @settings = settings.with_indifferent_access
      end

      def deliver!(mail)
        send_opts = {}
        send_opts[:raw_message] = {}
        send_opts[:raw_message][:data] = mail.to_s

        if mail.respond_to?(:destinations)
          send_opts[:destinations] = mail.destinations
        end

        client = Aws::SES::Client.new(settings)
        client.send_raw_email(send_opts).tap do |response|
          create_message! mail, response.message_id
          mail.message_id = "#{response.message_id}@email.amazonses.com"
        end
      end

      private

      def create_message!(mail, message_id)
        Message.create!(
          uuid: message_id,
          token: mail.instance_variable_get(:@_token),
          campaign_id: mail.instance_variable_get(:@_campaign_id),
          subscriber_id: mail.instance_variable_get(:@_subscriber_id),
          sent_at: Time.now
        )
      end
    end
  end
end
