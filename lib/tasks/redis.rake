namespace :redis do
  desc 'Remove dead queues on Resque'
  task remove_dead_queues: :environment do
    CampaignQueue.remove_dead_queues
  end

  desc 'Rebuild redis database from scratch'
  task rebuild: :environment do
    notifications = Query.select_all :campaign_notifications
    notifications.each do |row|
      counter_name = case row['type']
                     when '0' then :bounces_count
                     when '1' then :complaints_count
                     when '2' then :messages_count
                     end

      Campaign.reset_counter counter_name,
                             row['campaign_id'],
                             row['count'] if counter_name

      Campaign.increment_counter :messages_count,
                                 row['campaign_id'],
                                 row['count'] if counter_name.nil?
    end

    rates = Query.select_all :campaign_rates
    rates.each do |row|
      Campaign.reset_counter :unique_opens_count,
                             row['campaign_id'],
                             row['unique_opens_count']

      Campaign.reset_counter :unique_clicks_count,
                             row['campaign_id'],
                             row['unique_clicks_count']
    end
  end
end
