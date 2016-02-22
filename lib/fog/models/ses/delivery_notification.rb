module Fog
  module AWS
    class SES
      class DeliveryNotification < Fog::Model
        attribute :type, aliases: 'notificationType'
        attribute :delivery
        attribute :mail

        def delivery=(json)
          attributes[:delivery] = Delivery.new(json)
        end

        def mail=(json)
          attributes[:mail] = Mail.new(json)
        end
      end
    end
  end
end
