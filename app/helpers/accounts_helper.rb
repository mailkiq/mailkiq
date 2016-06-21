module AccountsHelper
  COLORS = {
    draft: :default,
    pending: :default,
    partially_paid: :warning,
    paid: :primary,
    canceled: :danger,
    refunded: :danger,
    expired: :danger
  }.freeze

  def invoice_status_tag(status)
    variation = COLORS[status.to_sym]
    text = t("simple_form.options.invoice.status.#{status}")
    content_tag :span, text, class: "label-#{variation}"
  end

  def registration_form_tag(&block)
    simple_form_for resource, as: resource_name,
                              url: registration_path(resource_name),
                              html: { method: :put }, &block
  end
end
