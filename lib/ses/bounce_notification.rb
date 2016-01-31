module SES
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
  end
end
