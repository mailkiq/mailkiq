module DomainsHelper
  COLORS = {
    pending: :default,
    success: :primary,
    failed: :danger,
    temporary_failure: :danger,
    not_started: :default
  }.freeze

  def domain_status_tag(status)
    variation = COLORS[status.to_sym]
    text = t("simple_form.options.domain.status.#{status}")
    content_tag :span, text, class: "label-#{variation}"
  end

  def domain_icon_tag(status)
    if status.include? 'pending'
      content_tag :span, nil, class: 'ss-hyphen'
    elsif status.include? 'success'
      content_tag :span, nil, class: 'ss-check'
    end
  end
end
