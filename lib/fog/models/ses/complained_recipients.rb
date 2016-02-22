module Fog
  module AWS
    class SES
      class ComplainedRecipients < Fog::Collection
        model ComplainedRecipient
      end
    end
  end
end
