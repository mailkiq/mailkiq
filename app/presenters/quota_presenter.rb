QuotaPresenter = Struct.new(:account, :view_context) do
  delegate :t, :pluralize, :number_with_delimiter, :content_tag,
           to: :view_context

  def ses
    @ses ||= Fog::AWS::SES.new account.credentials
  end

  def send_quota
    @quota ||= Rails.cache.fetch [account.cache_key, :send_quota] do
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

  def progress_bar_tag
    percentage = sent_last_hours * 100 / max_hour_send
    content_tag :div, nil, style: "width: #{percentage}%",
                           class: 'progress-bar progress-bar-info'
  end

  def metrics
    campaigns = account.campaigns.select(:id)
    Message.where(campaign_id: campaigns).group_by_day(:sent_at, dates: true).count
  end
end
