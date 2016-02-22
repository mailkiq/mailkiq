module Fog
  module AWS
    class SES
      class BouncedRecipients < Fog::Collection
        model SES::BouncedRecipient
      end
    end
  end
end
