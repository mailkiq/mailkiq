class QuotaPresenter < Presenter
  delegate :max_24_hour_send, to: :send_quota
  delegate :sent_last_24_hours, to: :send_quota
  delegate :max_send_rate, to: :send_quota

  def sandbox?
    max_24_hour_send == 200
  end

  def human_send_rate
    t 'dashboard.show.send_rate', rate: pluralize(max_send_rate.to_i, 'email')
  end

  def human_sending_limits
    t 'dashboard.show.sending_limits',
      count: number_with_delimiter(sent_last_24_hours),
      remaining: number_with_delimiter(max_24_hour_send)
  end

  def sandbox_badge_tag
    content_tag :span, t('dashboard.show.sandbox'), class: 'label label-default'
  end

  def send_quota
    model.quota.cached(:send_quota)
  end

  def send_statistics
    model.quota.cached(:send_statistics)
  end
end
