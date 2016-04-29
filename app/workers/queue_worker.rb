class QueueWorker
  def initialize(account)
    @account = account
    @client = Aws::SQS::Client.new(@account.aws_options)
    @poller = Aws::SQS::QueuePoller.new(@account.aws_queue_url, client: @client)
  end

  def size
    resp = @client.get_queue_attributes(
      queue_url: @account.aws_queue_url,
      attribute_names: ['ApproximateNumberOfMessages']
    )

    resp.attributes['ApproximateNumberOfMessages'].to_i
  end

  def poll
    @poller.poll(idle_timeout: 20, max_number_of_messages: 10) do |messages|
      messages.each do |msg|
        manager = NotificationManager.new(msg.body, @account.id)
        manager.create! if manager.ses?
      end
    end
  end
end
