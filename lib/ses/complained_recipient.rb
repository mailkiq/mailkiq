module SES
  class ComplainedRecipient < Fog::Model
    attribute :email, aliases: 'emailAddress'
  end
end
