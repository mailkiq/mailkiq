require_dependency 'query'

module CounterCache
  module_function

  def reset_notification_rates
    Query.select_all(:campaign_notifications).each do |row|
      counter_name = column_name_for_type row['type']

      Campaign.reset_counter \
        counter_name, row['campaign_id'], row['count'] if counter_name

      Campaign.increment_counter \
        :messages_count, row['campaign_id'], row['count'] if counter_name.nil?
    end
  end

  def reset_message_rates
    Query.select_all(:campaign_rates).each do |row|
      Campaign.reset_counter \
        :unique_opens_count, row['campaign_id'], row['unique_opens_count']

      Campaign.reset_counter \
        :unique_clicks_count, row['campaign_id'], row['unique_clicks_count']
    end
  end

  def column_name_for_type(type)
    case type
    when '0' then :bounces_count
    when '1' then :complaints_count
    when '2' then :messages_count
    end
  end
end
