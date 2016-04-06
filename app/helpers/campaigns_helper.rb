module CampaignsHelper
  def percentage_badge_tag(number, total)
    value = number.to_f * 100 / (total.zero? ? 1 : total)
    precision = value.zero? ? 0 : 1
    percentage = number_to_percentage(value, precision: precision)
    content_tag :span, percentage, class: 'label-percentage'
  end

  def campaign_progress_tag(campaign)
    ProgressPresenter.new(campaign, self).render
  end
end
