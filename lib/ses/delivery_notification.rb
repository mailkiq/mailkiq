module SES
  class DeliveryNotification < Fog::Model
    attribute :type, aliases: 'notificationType'
    attribute :delivery
    attribute :mail

    def delivery=(json)
      attributes[:delivery] = SES::Delivery.new(json)
    end

    def mail=(json)
      attributes[:mail] = SES::Mail.new(json)
    end
  end
end
