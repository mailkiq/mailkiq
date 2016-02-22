module Fog
  module AWS
    class SES
      class Complaint < Fog::Model
        identity :id, aliases: 'feedbackId'
        attribute :arrival_date, aliases: 'arrivalDate', type: :timestamp
        attribute :complaint_feedback_type, aliases: 'complaintFeedbackType'
        attribute :complained_recipients, aliases: 'complainedRecipients'
        attribute :user_agent, aliases: 'userAgent'
        attribute :timestamp, type: :timestamp

        def complained_recipients=(json)
          attributes[:complained_recipients] = ComplainedRecipients.new.load(json)
        end

        def as_json
          json = attributes.dup
          json[:complained_recipients] = complained_recipients.map(&:email)
          json
        end
      end
    end
  end
end
