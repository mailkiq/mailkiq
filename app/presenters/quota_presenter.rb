QuotaPresenter = Struct.new(:account, :view_context) do
  delegate :t, :pluralize, :number_with_delimiter, :content_tag,
           to: :view_context

  def send_quota
    @quota ||= cache(:send_quota) { ses.get_send_quota.body }
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

  def send_statistics
    cache :send_statistics do
      values = ses.get_send_statistics.body['SendDataPoints'].each do |data|
        data['Timestamp'] = Time.zone.parse(data['Timestamp']).to_date
      end

      values.group_by { |d| d['Timestamp'] }.map do |k, v|
        {
          Timestamp: k,
          Complaints: v.map { |c| c['Complaints'].to_i }.inject(:+),
          Rejects: v.map { |c| c['Rejects'].to_i }.inject(:+),
          Bounces: v.map { |c| c['Bounces'].to_i }.inject(:+),
          DeliveryAttempts: v.map { |c| c['DeliveryAttempts'].to_i }.inject(:+)
        }
      end
    end
  end

  private

  def ses
    @ses ||= Fog::AWS::SES.new account.credentials
  end

  def cache(name, &block)
    Rails.cache.fetch("#{account.cache_key}/#{name}", &block)
  end
end
