module Fog
  module AWS
    class SES
      class ComplaintNotification < Fog::Model
        attribute :type, aliases: 'notificationType'
        attribute :complaint
        attribute :mail

        def complaint=(json)
          attributes[:complaint] = Complaint.new(json)
        end

        def mail=(json)
          attributes[:mail] = Mail.new(json)
        end

        def as_json
          {
            type: type,
            complaint: complaint.as_json,
            mail: mail.attributes
          }
        end
      end
    end
  end
end