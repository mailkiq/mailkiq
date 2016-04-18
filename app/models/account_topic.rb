require_dependency 'url_helpers'

class AccountTopic
  attr_reader :account, :client

  def initialize(account)
    @account = account
    @client = Aws::SNS::Client.new(account.aws_options)
  end

  def name
    account.tied_to_mailkiq? ? "mailkiq-#{account.id}" : 'mailkiq'
  end

  def up
    response = client.create_topic name: name

    client.subscribe topic_arn: response.topic_arn,
                     endpoint: api_v1_notifications_url,
                     protocol: :http

    account.update_column :aws_topic_arn, response.topic_arn
  end

  def down
    client.delete_topic topic_arn: account.aws_topic_arn
  end

  private

  def api_v1_notifications_url
    URLHelpers.api_v1_notifications_url api_key: account.api_key
  end
end
