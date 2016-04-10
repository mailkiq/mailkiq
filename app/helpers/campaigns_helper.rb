module CampaignsHelper
  def campaign_percentage_tag(campaign, counter_name, css_class: nil)
    count = campaign.send(counter_name).to_f
    total = (campaign.recipients_count.zero? ? 1 : campaign.recipients_count)
    value = count * 100 / total
    precision = value.zero? || value >= 10 ? 0 : 1
    content_tag :span, number_to_percentage(value, precision: precision),
                class: css_class || 'campaign-percentage'
  end

  def campaign_meter_tag(campaign, counter_name)
    width = campaign.send(counter_name).value / campaign.recipients_count
    content_tag :div, class: :meter do
      content_tag :span, nil, style: "width: #{width}%"
    end
  end

  def campaign_progress_tag(campaign)
    ProgressPresenter.new(campaign, self).render
  end
end
