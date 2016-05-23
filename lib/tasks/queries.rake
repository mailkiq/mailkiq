require 'query'

namespace :queries do
  desc 'Update campaigns counter cache columns'
  task update_counters: :environment do
    Query.execute :update_counters
  end

  desc 'Remove duplicated notifications'
  task remove_duplicates: :environment do
    Query.execute :remove_duplicated_notifications
  end

  desc 'Update message status column'
  task update_messages: :environment do
    Query.execute :update_message_status
  end
end
