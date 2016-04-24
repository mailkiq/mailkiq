class Quota
  attr_reader :account, :ses

  def initialize(account)
    @account = account
    @ses = Aws::SES::Client.new(account.aws_options)
  end

  def remaining
    account.plan_credits - account.used_credits.value
  end

  def exceed?(value)
    remaining < value
  end

  def send_quota
    ses.get_send_quota.as_json
  end

  def send_statistics
    values = ses.get_send_statistics.send_data_points
    values = values.group_by { |data| data.timestamp.to_date }
    values = values.map { |k, v| build_data_point k, v }
    values.sort_by! { |hash| hash[:Timestamp] }
  end

  def cached(method_name)
    cache_key = "#{account.cache_key}/#{method_name}"
    value = Rails.cache.fetch(cache_key, expires_in: 1.day) { send method_name }
    value.is_a?(Hash) ? OpenStruct.new(value) : value
  end

  private

  def build_data_point(k, v)
    {
      Timestamp: k,
      Complaints: v.map(&:complaints).inject(:+),
      Bounces: v.map(&:bounces).inject(:+) + v.map(&:rejects).inject(:+),
      DeliveryAttempts: v.map(&:delivery_attempts).inject(:+)
    }
  end
end