module SNS
  class Notification < Fog::Model
    identity :id, aliases: 'MessageId'
    attribute :type, aliases: 'Type'
    attribute :topic_arn, aliases: 'TopicArn'
    attribute :timestamp, aliases: 'Timestamp', type: :timestamp
    attribute :signature_version, aliases: 'SignatureVersion'
    attribute :signature, aliases: 'Signature'
    attribute :signing_cert_url, aliases: 'SigningCertURL'
    attribute :subscribe_url, aliases: 'SubscribeURL'
    attribute :unsubscribe_url, aliases: 'UnsubscribeURL'
    attribute :message, aliases: 'Message'
    attribute :token, aliases: 'Token'

    def subscription_confirmation?
      type == 'SubscriptionConfirmation'
    end

    def ses?
      message.respond_to?(:complaint) ||
        message.respond_to?(:bounce) ||
        message.respond_to?(:delivery)
    end

    def emails
      if message.respond_to?(:complaint)
        message.complaint.complained_recipients.map(&:email)
      elsif message.respond_to?(:bounce)
        message.bounce.bounced_recipients.map(&:email)
      else
        message.delivery.recipients
      end
    end

    def state
      if message.respond_to?(:complaint)
        :complained
      elsif message.respond_to?(:bounce)
        :bounced
      elsif message.respond_to?(:delivery)
        :active
      end
    end

    def data
      if message.respond_to?(:complaint)
        message.complaint
      elsif message.respond_to?(:bounce)
        message.bounce
      elsif message.respond_to?(:delivery)
        message.delivery
      end
    end

    def message=(value)
      payload = Fog::JSON.decode(value)
      klass = if payload.key? 'complaint'
                SES::ComplaintNotification
              elsif payload.key? 'bounce'
                SES::BounceNotification
              elsif payload.key? 'delivery'
                SES::DeliveryNotification
              end

      attributes[:message] = klass.new(payload)
    rescue Fog::JSON::DecodeError
      attributes[:message] = value
    end
  end
end
