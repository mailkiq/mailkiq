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
    # In practice, there should be no records with pending states more than
    # a few minutes after the sending is completed.
    Message.where(state: :pending).update_all state: Message.states[:delivery]

    # Just remember to execute update_counters after this.
    Query.execute :update_message_status
  end
end
