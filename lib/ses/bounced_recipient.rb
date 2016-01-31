module SES
  class BouncedRecipient < Fog::Model
    attribute :action
    attribute :email, aliases: 'emailAddress'
    attribute :status
    attribute :diagnostic_code, aliases: 'diagnosticCode'
  end
end
