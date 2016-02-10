module SubscribersHelper
  COLORS = {
    active: :primary,
    unconfirmed: :default,
    unsubscribed: :default,
    complained: :warning,
    bounced: :danger,
    deleted: :danger
  }

  def state_badge_tag(state)
    variation = COLORS[state.to_sym]
    content_tag :span, state.capitalize, class: "label label-#{variation}"
  end
end
