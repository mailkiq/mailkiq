module SNS
  class Messages < Fog::Collection
    model SQS::Message
  end
end
