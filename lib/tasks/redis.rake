namespace :redis do
  desc 'Rebuild redis database from scratch'
  task rebuild: :environment do
    CounterCache.reset_notification_rates
    CounterCache.reset_message_rates
  end
end
