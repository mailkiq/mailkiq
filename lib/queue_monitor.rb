require 'sidekiq/util'

class QueueMonitor
  include Sidekiq::Util

  def wait
    sleep 5.minutes
  end

  def check
    redis do |conn|
      queues = conn.smembers(:queues).grep(/campaign/)
      queues.each do |queue|
        conn.srem(:queues, queue) if conn.llen("queue:#{queue}").zero?
      end
    end
  end

  def start
    safe_thread 'queue_monitor' do
      logger.info 'Starting queue monitoring thread'

      loop do
        check
        wait
      end
    end
  end
end
