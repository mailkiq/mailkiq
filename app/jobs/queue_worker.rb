class QueueWorker
  include Concurrent::Concern::Logging

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
  rescue Seahorse::Client::NetworkingError
    0
  end

  def account_id
    @account.id
  end

  def poll
    @poller.poll(idle_timeout: 5) do |msg|
      begin
        manager = NotificationManager.new(msg.body, @account.id)
        manager.create! if manager.ses?
      rescue ActiveRecord::RecordNotFound
        log DEBUG, "Skipping message on queue ##{account_id}"
        throw :skip_delete if ENV['SQS_SKIP_DELETE']
      end
    end
  rescue Seahorse::Client::NetworkingError => ex
    thread_id = Thread.current.object_id.to_s(36)
    log DEBUG, "Thread TID-#{thread_id} died with #{ex.message}"
  end
end
