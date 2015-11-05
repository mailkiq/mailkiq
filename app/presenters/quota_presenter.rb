class QuotaPresenter < Struct.new(:account, :view_context)
  delegate :t, :content_tag, to: :view_context

  def ses
    @ses ||= Fog::AWS::SES.new account.slice(:aws_access_key_id, :aws_secret_access_key)
  end

  def send_quota
    @quota ||= ses.get_send_quota.body
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

  def sandbox_badge_tag
    content_tag :span, t('dashboard.index.sandbox'), class: 'label label-default' if sandbox?
  end

  def progress_bar_tag
    percentage = sent_last_hours * 100 / max_hour_send
    content_tag :div, nil, style: "width: #{percentage}%",
      class: 'progress-bar progress-bar-info'
  end
end
