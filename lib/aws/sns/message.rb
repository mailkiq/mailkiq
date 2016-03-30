module Aws
  module SNS
    class Message
      attr_reader :attributes

      def initialize(attributes)
        @attributes = attributes
        @attributes['Message'] = JSON.parse(@attributes['Message']) rescue nil
      end

      def self.load(json)
        new JSON.parse(json)
      end

      def subscription_confirmation?
        @attributes['Type'] == 'SubscriptionConfirmation'
      end

      def topic_arn
        @attributes['TopicArn']
      end

      def token
        @attributes['Token']
      end

      def mail_id
        search 'Message.mail.messageId'
      end

      def message_type
        search('Message.notificationType')
      end

      def state
        if message_type == 'Bounce'
          :bounced
        elsif message_type == 'Complaint'
          :complained
        elsif message_type == 'Delivery'
          :active
        end
      end

      def emails
        if message_type == 'Bounce'
          search('Message.bounce.bouncedRecipients[*].emailAddress')
        elsif message_type == 'Complaint'
          search('Message.complaint.complainedRecipients[*].emailAddress')
        elsif message_type == 'Delivery'
          search('Message.delivery.recipients')
        end
      end

      def ses?
        data.present?
      end

      def data
        search('Message.bounce') ||
          search('Message.complaint') ||
          search('Message.delivery')
      end

      private

      def search(path)
        JMESPath.search(path, attributes)
      end
    end
  end
end
