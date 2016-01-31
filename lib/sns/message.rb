module SNS
  class Message < Fog::Model
    identity :id, aliases: 'MessageId'
    attribute :self_attributes, aliases: 'Attributes'
    attribute :receipt_handle, aliases: 'ReceiptHandle'
    attribute :body, aliases: 'Body'
    attribute :md5_of_body, aliases: 'MD5OfBody'
    attribute :md5_of_message_attributes, aliases: 'MD5OfMessageAttributes'
    attribute :message_attributes, aliases: 'MessageAttributes'

    def body=(json)
      attributes[:body] = SQS::Notification.new Fog::JSON.decode(json)
    end
  end
end
