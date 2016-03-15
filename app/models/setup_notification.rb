require_dependency 'url_helpers'

class SetupNotification
  def initialize(account)
    @account = account
    @sns = Fog::AWS::SNS.new(account.credentials)
  end

  def up
    topic_arn = @sns.create_topic("mailkiq-#{@account.id}").body['TopicArn']
    @sns.subscribe topic_arn, api_v1_notifications_url, :http
    @account.update_column :aws_topic_arn, topic_arn
  end

  def down
    @sns.delete_topic(@account.aws_topic_arn)
  end

  private

  def api_v1_notifications_url
    URLHelpers.api_v1_notifications_url(api_key: @account.api_key)
  end
end
