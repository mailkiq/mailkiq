class ProgressPresenter < BasePresenter
  alias campaign record

  def render
    content_tag :div, class: 'meter progress' do
      bar :deliveries
      bar :bounces
      bar :complaints
      bar :unsent
    end
  end

  private

  def percentage_for(counter_name)
    total = campaign.recipients_count
    total = 1 if total.zero?
    count = campaign.send("#{counter_name}_count")
    count = count.value if count.respond_to? :value
    count / total.to_f * 100
  end

  def bar(counter_name)
    style = "width: #{percentage_for(counter_name).round}%"
    concat content_tag(:span, nil, style: style, class: counter_name)
  end
end
