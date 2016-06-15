class CampaignPresenter < Presenter
  delegate :name, :recipients_count, :to_percentage, :bounces_count,
           :unsent_count, :messages_count, :complaints_count, to: :model

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

    recipients = number_with_delimiter(model.recipients_count)
    time = l(model.sent_at, format: :long)
    text = t('campaigns.show.long_sent_at',
             time: time, recipients_count: recipients)

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
    width = model.send(counter_name) / model.recipients_count.to_f * 100
    width = width.round(1)
    content_tag :div, class: :meter do
      content_tag :span, nil, style: "width: #{width}%"
    end
  end

  private

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
