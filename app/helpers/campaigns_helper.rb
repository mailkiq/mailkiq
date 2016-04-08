module CampaignsHelper
  def campaign_percentage_tag(campaign, counter_name)
    count = campaign.send(counter_name).to_f
    total = (campaign.recipients_count.zero? ? 1 : campaign.recipients_count)
    value = count * 100 / total
    percentage = number_to_percentage(value, precision: value.zero? ? 0 : 1)

    content_tag :span, percentage, class: 'campaign-percentage'
  end

  def campaign_progress_tag(campaign)
    ProgressPresenter.new(campaign, self).render
  end
end
