require 'dynamic_fetch'

Sidekiq.options[:fetch] = DynamicFetch
