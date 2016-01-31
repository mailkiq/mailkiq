module SES
  class Mail < Fog::Model
    identity :id, aliases: 'messageId'
    attribute :timestamp, type: :timestamp
    attribute :source_arn, aliases: 'sourceArn'
    attribute :sending_account_id, aliases: 'sendingAccountId'
    attribute :source
    attribute :destination
  end
end
