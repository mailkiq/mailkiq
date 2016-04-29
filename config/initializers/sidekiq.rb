require 'dynamic_fetch'
require 'queue_monitor'

Sidekiq.options[:fetch] = DynamicFetch

Sidekiq.configure_server do |config|
  config.on(:startup) do
    QueueMonitor.start
  end
end
