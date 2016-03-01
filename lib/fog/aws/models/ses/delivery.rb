module Fog
  module AWS
    class SES
      class Delivery < Fog::Model
        attribute :reporting_mta, aliases: 'reportingMTA'
        attribute :processing_time_millis, aliases: 'processingTimeMillis'
        attribute :smtp_response, aliases: 'smtpResponse'
        attribute :recipients
        attribute :timestamp, type: :time

        alias_method :as_json, :attributes
      end
    end
  end
end
