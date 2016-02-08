module SES
  class Delivery < Fog::Model
    attribute :reporting_mta, aliases: 'reportingMTA'
    attribute :processing_time_millis, aliases: 'processingTimeMillis'
    attribute :smtp_response, aliases: 'smtpResponse'
    attribute :recipients
    attribute :timestamp, type: :timestamp

    alias_method :as_json, :attributes
  end
end
