namespace :sqs do
  desc 'Process SQS messages using a worker pool'
  task work: :environment do
    $stdout.sync = true

    Concurrent.use_stdlib_logger Logger::DEBUG, $stdout

    accounts = Account.activated.all
    accounts.each(&:readonly!)

    pool = Concurrent::ThreadPoolExecutor.new(
      min_threads: ENV['QUE_WORKER_COUNT'] || 25,
      max_threads: ENV['QUE_WORKER_COUNT'] || 25,
      max_queue: ENV['QUE_WORKER_COUNT'] || 25
    )

    stop = false
    curr = Thread.current

    %w(INT TERM).each do |signal|
      trap(signal) do
        stop = true
        curr.wakeup
      end
    end

    at_exit do
      $stdout.puts 'Immediately shutting down the pool...'
      pool.kill
      $stdout.puts 'SQS worker exited...'
    end

    loop do
      accounts.each do |account|
        break if stop

        worker = QueueWorker.new(account)
        size = worker.size
        $stdout.puts "Queue ##{account.id} has #{size} pending messages"

        next if size.zero?
        next if pool.remaining_capacity.zero?

        $stdout.puts "Remaining capacity: #{pool.remaining_capacity}"

        worker.poller.before_request { throw :stop_polling if stop }

        pool.post do
          worker.poll
          ::ActiveRecord::Base.clear_active_connections!
        end
      end

      break if stop

      sleep 20
    end
  end
end
