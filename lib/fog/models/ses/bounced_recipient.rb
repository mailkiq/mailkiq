module Fog
  module AWS
    class SES
      class BouncedRecipient < Fog::Model
        attribute :action
        attribute :email, aliases: 'emailAddress'
        attribute :status
        attribute :diagnostic_code, aliases: 'diagnosticCode'
      end
    end
  end
end
