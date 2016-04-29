class AccountActivation
  MESSAGE_RETENTION_PERIOD = '1209600'.freeze # 14 days
  RECEIVE_MESSAGE_WAIT_TIME_SECONDS = '20'.freeze
  VISIBILITY_TIMEOUT = '10'.freeze

  attr_reader :account, :sns, :sqs

  def initialize(account)
    @account = account
    @sns = Aws::SNS::Client.new(account.aws_options)
    @sqs = Aws::SQS::Client.new(account.aws_options)
  end

  def name
    parts = []
    parts << 'mailkiq'
    parts << account.id if account.tied_to_mailkiq?
    parts.join('-')
  end

  def activate
    topic_arn = sns.create_topic(name: name).topic_arn
    queue_url = create_queue.queue_url
    endpoint = queue_arn_from_url(queue_url)

    sns.subscribe topic_arn: topic_arn, endpoint: endpoint, protocol: :sqs

    account.update_columns aws_topic_arn: topic_arn, aws_queue_url: queue_url
  end

  def deactivate
    sns.delete_topic topic_arn: account.aws_topic_arn
    sqs.delete_queue queue_url: account.aws_queue_url
    account.update_columns aws_topic_arn: nil, aws_queue_url: nil
  end

  private

  def create_queue
    sqs.create_queue(
      queue_name: name,
      attributes: {
        'MessageRetentionPeriod' => MESSAGE_RETENTION_PERIOD,
        'ReceiveMessageWaitTimeSeconds' => RECEIVE_MESSAGE_WAIT_TIME_SECONDS,
        'VisibilityTimeout' => VISIBILITY_TIMEOUT
      }
    )
  end

  def queue_arn_from_url(queue_url)
    sqs.get_queue_attributes(
      queue_url: queue_url,
      attribute_names: ['QueueArn']
    ).attributes['QueueArn']
  end
end
