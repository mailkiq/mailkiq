class CampaignPresenter < Presenter
  delegate :name, :recipients_count, :to_percentage, to: :model

  def estimated_time
    send_quota = model.account.quota.cached(:send_quota)
    time = model.recipients_count / send_quota.max_send_rate
    distance_of_time_in_words(model.sent_at, model.sent_at + time)
  end

  def delivered
    number_to_percentage to_percentage(:messages_count)
  end

  def bounces
    number_to_percentage to_percentage(:bounces_count)
  end

  def complaints
    number_to_percentage to_percentage(:complaints_count)
  end

  def unsent
    number_to_percentage to_percentage(:unsent_count)
  end

  def long_sent_at
    return nil unless model.sent_at?

    time = l(model.sent_at, format: :long)
    text = t 'campaigns.show.long_sent_at', time: time,
                                            estimated_time: estimated_time

    content_tag :small, text
  end

  def progress
    content_tag :div, class: 'meter progress' do
      bar :deliveries_count
      bar :bounces_count
      bar :complaints_count
      bar :unsent_count
    end
  end

  def meter_tag(counter_name)
    width = model.send(counter_name).value / model.recipients_count.to_f * 100
    width = width.round(1)
    content_tag :div, class: :meter do
      content_tag :span, nil, style: "width: #{width}%"
    end
  end

  private

  def _recipients_count
    @recipients_count ||= [1, model.recipients_count.to_f].max
  end

  def number_to_percentage(value)
    precision = value < 1 && !value.zero? ? 2 : 0
    __getobj__.number_to_percentage(value, precision: precision)
  end

  def bar(counter_name)
    css_class = counter_name.to_s.sub('_count', '')
    style = "width: #{to_percentage(counter_name).round}%"
    concat content_tag(:span, nil, style: style, class: css_class)
  end
end
