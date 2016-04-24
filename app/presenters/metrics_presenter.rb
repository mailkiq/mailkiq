class MetricsPresenter < BasePresenter
  alias campaign record

  def estimated_time
    send_quota = campaign.account.quota.cached(:send_quota)
    time = campaign.recipients_count / send_quota.max_send_rate
    distance_of_time_in_words(campaign.sent_at, campaign.sent_at + time)
  end

  def delivered
    percentage_for :messages_count
  end

  def bounces
    percentage_for :bounces_count
  end

  def complaints
    percentage_for :complaints_count
  end

  def unsent
    percentage_for :unsent_count
  end

  private

  def recipients_count
    value = campaign.recipients_count.to_f
    value.zero? ? 1 : value
  end

  def percentage_for(counter_name)
    counter = campaign.send(counter_name)
    counter = counter.value if counter.respond_to?(:value)
    value = counter / recipients_count * 100
    number_to_percentage(value, precision: value < 1 && !value.zero? ? 2 : 0)
  end
end
