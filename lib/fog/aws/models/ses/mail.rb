module Fog
  module AWS
    class SES
      class Mail < Fog::Model
        identity :id, aliases: 'messageId'
        attribute :timestamp, type: :time
        attribute :source_arn, aliases: 'sourceArn'
        attribute :sending_account_id, aliases: 'sendingAccountId'
        attribute :source
        attribute :destination
      end
    end
  end
end
