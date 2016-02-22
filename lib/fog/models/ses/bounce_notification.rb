module Fog
  module AWS
    class SES
      class BounceNotification < Fog::Model
        attribute :type, aliases: 'notificationType'
        attribute :bounce
        attribute :mail

        def bounce=(json)
          attributes[:bounce] = SES::Bounce.new(json)
        end

        def mail=(json)
          attributes[:mail] = SES::Mail.new(json)
        end

        def as_json
          {
            type: type,
            bounce: bounce.as_json,
            mail: mail.attributes
          }
        end
      end
    end
  end
end
