class ProgressPresenter < BasePresenter
  alias campaign record

  def render
    content_tag :div, class: 'meter progress' do
      bar :messages
      bar :bounces
      bar :complaints
      bar :rejects
      bar :unsent
    end
  end

  private

  def percentage_for(counter_name)
    total = campaign.recipients_count
    total = 1 if total.zero?

    count = campaign.send("#{counter_name}_count")
    count = count.value if count.respond_to? :value

    count / total * 100
  end

  def bar(counter_name, value: nil)
    width = value || percentage_for(counter_name)
    concat content_tag(:span, nil, style: "width: #{width}%", class: counter_name)
  end
end
