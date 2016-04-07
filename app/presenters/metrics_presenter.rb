class MetricsPresenter < BasePresenter
  alias campaign record

  def delivered
    percentage_for :messages_count
  end

  def bounces
    percentage_for :bounces_count
  end

  def complaints
    percentage_for :complaints_count
  end

  def rejects
    percentage_for :rejects_count
  end

  def unsent
    percentage_for :unsent_count
  end

  private

  def recipients_count
    value = campaign.recipients_count
    value.zero? ? 1 : value
  end

  def percentage_for(counter_name)
    counter = campaign.send(counter_name)
    counter = counter.value if counter.respond_to?(:value)
    number_to_percentage(counter / recipients_count * 100, precision: 0)
  end
end
