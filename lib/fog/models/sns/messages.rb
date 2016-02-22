module Fog
  module AWS
    class SNS
      class Messages < Fog::Collection
        model SQS::Message
      end
    end
  end
end
