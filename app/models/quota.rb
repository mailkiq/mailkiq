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
    values.sort_by! { |hash| hash[:timestamp] }
  end

  def cached(method_name)
    key = "#{account.aws_cache_key}/#{method_name}"
    value = Rails.cache.fetch(key, expires_in: 2.hours) { send method_name }
    value.is_a?(Hash) ? OpenStruct.new(value) : value
  end

  private

  def build_data_point(timestamp, values)
    {
      timestamp: timestamp,
      complaints: values.map(&:complaints).inject(:+),
      bounces: values.map(&:bounces).inject(:+),
      delivery_attempts: values.map(&:delivery_attempts).inject(:+),
      rejects: values.map(&:rejects).inject(:+)
    }
  end
end
