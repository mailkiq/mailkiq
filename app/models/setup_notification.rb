require_dependency 'url_helpers'

class SetupNotification
  def initialize(account)
    @account = account
    @sns = Aws::SNS::Client.new(account.credentials)
  end

  def up
    response = @sns.create_topic name: "mailkiq-#{@account.id}"

    @sns.subscribe topic_arn: response.topic_arn,
                   endpoint: api_v1_notifications_url,
                   protocol: :http

    @account.update_column :aws_topic_arn, response.topic_arn
  end

  def down
    @sns.delete_topic topic_arn: @account.aws_topic_arn
  end

  private

  def api_v1_notifications_url
    URLHelpers.api_v1_notifications_url api_key: @account.api_key
  end
end
