class ProgressPresenter < BasePresenter
  alias campaign record

  def render
    content_tag :div, class: :progress do
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
    width = (value.nil? ? percentage_for(counter_name) : value) * 980 / 100
    concat content_tag(:span, nil, style: "width: #{width}px", class: counter_name)
  end
end
