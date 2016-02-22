module Fog
  module AWS
    class SES
      class ComplainedRecipient < Fog::Model
        identity :email, aliases: 'emailAddress'
      end
    end
  end
end
