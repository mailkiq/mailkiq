module SES
  class ComplaintNotification < Fog::Model
    attribute :type, aliases: 'notificationType'
    attribute :complaint
    attribute :mail

    def complaint=(json)
      attributes[:complaint] = SES::Complaint.new(json)
    end

    def mail=(json)
      attributes[:mail] = SES::Mail.new(json)
    end

    def as_json(_options = {})
      {
        type: type,
        complaint: complaint.as_json,
        mail: mail.attributes
      }
    end
  end
end
