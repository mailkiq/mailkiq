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
  end
end
