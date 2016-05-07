class QueueSupervisor
  include Concurrent::Concern::Logging

  def initialize
    @accounts = Account.active.all
    @accounts.each(&:readonly!)
    @workers = @accounts.map { |account| QueueWorker.new account }
    @pool = Concurrent::ThreadPoolExecutor.new(
      min_threads: ENV['SIDEKIQ_CONCURRENCY'] || 50,
      max_threads: ENV['SIDEKIQ_CONCURRENCY'] || 50,
      max_queue: ENV['SIDEKIQ_CONCURRENCY'] || 50
    )
  end

  def wait
    sleep 20
  end

  def batch_process(worker)
    log DEBUG, "Remaining capacity: #{@pool.remaining_capacity}"

    @pool.post { worker.poll } unless @pool.remaining_capacity.zero?
  end

  def start
    loop do
      @workers.each do |worker|
        size = worker.size
        log DEBUG, "Queue ##{worker.account_id} has #{size} pending messages"
        batch_process(worker) unless size.zero?
      end
      wait
    end
  end
end
