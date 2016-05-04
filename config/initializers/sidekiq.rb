require 'dynamic_fetch'
require 'queue_monitor'

Sidekiq.options[:strict] = false
Sidekiq.options[:fetch] = DynamicFetch

Sidekiq.configure_server do |config|
  config.on(:startup) do
    monitor = QueueMonitor.new
    monitor.start
  end
end
