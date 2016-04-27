require 'sidekiq/fetch'

class DynamicFetch < Sidekiq::BasicFetch
  def queues_cmd
    queues = Sidekiq.redis { |conn| conn.smembers :queues }
    queues.map! { |queue| "queue:#{queue}" }
    return super if queues.empty?

    @queues = queues

    super
  end
end
