module SES
  class Complaint < Fog::Model
    identity :id, aliases: 'feedbackId'
    attribute :complaint_feedback_type, aliases: 'complaintFeedbackType'
    attribute :complained_recipients, aliases: 'complainedRecipients'
    attribute :user_agent, aliases: 'userAgent'
    attribute :timestamp, type: :timestamp

    def complained_recipients=(json)
      attributes[:complained_recipients] = SES::ComplainedRecipients.new.load(json)
    end
  end
end
