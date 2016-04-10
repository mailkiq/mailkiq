class QuotaPresenter < BasePresenter
  alias account record

  delegate :max_24_hour_send, :max_send_rate, :sent_last_24_hours, to: :quota

  def quota
    cache :quota, serializer: Aws::SES::Types::GetSendQuotaResponse do
      ses.get_send_quota.as_json
    end
  end

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

  def send_statistics
    cache :send_statistics do
      values = ses.get_send_statistics.send_data_points
      values = values.group_by { |data| data.timestamp.to_date }.map do |k, v|
        {
          Timestamp: k,
          Complaints: v.map(&:complaints).inject(:+),
          Rejects: v.map(&:rejects).inject(:+),
          Bounces: v.map(&:bounces).inject(:+),
          DeliveryAttempts: v.map(&:delivery_attempts).inject(:+)
        }
      end
      values.sort_by! { |hash| hash[:Timestamp] }
    end
  end

  private

  def ses
    @ses ||= Aws::SES::Client.new(account.credentials)
  end

  def cache(name, serializer: nil, &block)
    cache_key = "#{account.cache_key}/#{name}"
    value = Rails.cache.fetch(cache_key, expires_in: 1.day, &block)
    serializer ? serializer.new(value) : value
  end
end
