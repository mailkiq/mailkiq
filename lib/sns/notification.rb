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

    def subscription_confirmation?
      type == 'SubscriptionConfirmation'
    end

    def complaint?
      message.respond_to? :complaint
    end

    def bounce?
      message.respond_to?(:bounce) && message.bounce.bounce_type == 'Permanent'
    end

    def emails
      if complaint?
        message.complaint.complained_recipients.map(&:email)
      elsif bounce?
        message.bounce.bounced_recipients.map(&:email)
      else
        []
      end
    end

    def message=(value)
      payload = Fog::JSON.decode(value)
      klass = if payload.key? 'complaint'
                SES::ComplaintNotification
              elsif payload.key? 'bounce'
                SES::BounceNotification
              end

      attributes[:message] = klass.new(payload)
    rescue Fog::JSON::DecodeError
      attributes[:message] = value
    end
  end
end
