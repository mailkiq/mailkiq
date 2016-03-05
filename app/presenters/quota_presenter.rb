QuotaPresenter = Struct.new(:account, :view_context) do
  delegate :t, :pluralize, :number_with_delimiter, :content_tag,
           to: :view_context

  def cache_key
    "#{account.cache_key}/send_quota"
  end

  def ses
    @ses ||= Fog::AWS::SES.new account.credentials
  end

  def send_quota
    @quota ||= Rails.cache.fetch cache_key, expires_in: 1.hour do
      ses.get_send_quota.body
    end
  end

  def sandbox?
    max_hour_send == 200
  end

  def max_send_rate
    send_quota['MaxSendRate'].to_i
  end

  def max_hour_send
    send_quota['Max24HourSend'].to_i
  end

  def sent_last_hours
    send_quota['SentLast24Hours'].to_i
  end

  def human_send_rate
    t 'dashboard.show.send_rate', rate: pluralize(max_send_rate, 'email')
  end

  def human_sending_limits
    t 'dashboard.show.sending_limits',
      count: number_with_delimiter(sent_last_hours),
      remaining: number_with_delimiter(max_hour_send)
  end

  def sandbox_badge_tag
    content_tag :span, t('dashboard.show.sandbox'), class: 'label label-default'
  end

  def to_json
    MetricQuery.sent_by_account(account).to_json
  end
end
