namespace :sqs do
  desc 'Process SQS messages using a worker pool'
  task work: :environment do
    $stdout.sync = true

    Concurrent.use_stdlib_logger Logger::DEBUG, $stdout

    accounts = Account.active.all
    workers = accounts.map { |account| QueueWorker.new account }
    pool = Concurrent::ThreadPoolExecutor.new(
      min_threads: ENV['QUE_WORKER_COUNT'] || 25,
      max_threads: ENV['QUE_WORKER_COUNT'] || 25,
      max_queue: ENV['QUE_WORKER_COUNT'] || 25
    )

    accounts.each(&:readonly!)

    stop = false
    %w(INT TERM).each do |signal|
      trap(signal) { stop = true }
    end

    at_exit do
      $stdout.puts 'Immediately shutting down the pool...'
      pool.kill
      $stdout.puts 'SQS worker exited...'
    end

    loop do
      workers.each do |worker|
        size = worker.size
        $stdout.puts "Queue ##{worker.account_id} has #{size} pending messages"

        next if size.zero?
        next if pool.remaining_capacity.zero?

        $stdout.puts "Remaining capacity: #{pool.remaining_capacity}"

        pool.post { worker.poll }
      end

      sleep 20

      break if stop
    end
  end
end
