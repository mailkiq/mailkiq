namespace :sqs do
  desc 'Start Amazon SQS worker'
  task worker: :environment do
    Concurrent.use_stdlib_logger Logger::DEBUG, $stdout

    supervisor = QueueSupervisor.new
    supervisor.start
  end
end
