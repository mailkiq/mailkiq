module SES
  class ComplainedRecipient < Fog::Model
    identity :email, aliases: 'emailAddress'
  end
end
