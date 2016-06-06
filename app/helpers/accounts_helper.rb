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

  def mixpanel_properties(account)
    {
      :$first_name => account.first_name,
      :$last_name  => account.last_name,
      :$created    => account.created_at,
      :$email      => account.email
    }
  end

  def invoice_status_tag(status)
    variation = COLORS[status.to_sym]
    text = t("simple_form.options.invoice.status.#{status}")
    content_tag :span, text, class: "label-#{variation}"
  end
end
