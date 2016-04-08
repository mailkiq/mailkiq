namespace :counter_cache do
  desc 'Update campaigns counter cache columns'
  task update: :environment do
    sql = File.readlines('db/queries/update_opens_and_clicks.sql').join
    ActiveRecord::Base.connection.execute(sql)
  end

  desc 'Rebuild redis database from scratch'
  task redis: :environment do
    sql = File.readlines('db/queries/campaign_notifications.sql').join
    rows = ActiveRecord::Base.connection.select_all(sql)
    rows.each do |row|
      counter_name = case row['type'].to_i
                     when 0 then :bounces_count
                     when 1 then :complaints_count
                     when 2 then :messages_count
                     end

      Campaign.reset_counter counter_name, row['campaign_id'], row['count']
    end
  end
end
