module DomainsHelper
  COLORS = {
    pending: :default,
    success: :primary,
    failed: :danger,
    temporary_failure: :danger,
    not_started: :default
  }

  def domain_status_tag(status)
    variation = COLORS[status.to_sym]
    text = t("simple_form.options.domain.status.#{status}")
    content_tag :span, text, class: "label-#{variation}"
  end
end
