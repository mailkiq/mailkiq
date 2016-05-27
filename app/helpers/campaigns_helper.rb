module CampaignsHelper
  COLORS = {
    draft: :default,
    queued: :default,
    scheduled: :default,
    sending: :primary,
    paused: :default,
    sent: :primary
  }.freeze

  def percentage_tag(value, css_class: 'percentage-balloon')
    precision = value.zero? || value >= 10 ? 0 : 1
    number = number_to_percentage(value, precision: precision)
    content_tag :span, number, class: css_class
  end

  def campaign_status_tag(status)
    variation = COLORS[status.to_sym]
    text = t("simple_form.options.campaign.state.#{status}")
    content_tag :span, text, class: "label-#{variation}"
  end
end
