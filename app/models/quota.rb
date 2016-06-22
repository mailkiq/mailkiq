class Quota
  def initialize(account)
    @account = account
    @billing = Billing.new(@account)
    @ses = Aws::SES::Client.new(@account.aws_options)
  end

  def remaining
    @billing.plan_credits - @account.used_credits
  end

  def exceed?(value)
    if @account.iugu?
      @account.expired? || remaining < value
    else
      false
    end
  end

  def use!(count)
    @account.increment! :used_credits, count
  end

  def send_quota
    @ses.get_send_quota.as_json
  end

  def send_statistics
    values = @ses.get_send_statistics.send_data_points
    values = values.group_by { |data| prepare_date data.timestamp }
    values = values.map { |k, v| build_data_point k, v }
    values.sort_by! { |data| data[:timestamp] }
  end

  def cached(method_name)
    key = "#{@account.cache_key}/#{method_name}"
    value = Rails.cache.fetch(key, expires_in: 2.hours) { send method_name }
    value.is_a?(Hash) ? OpenStruct.new(value) : value
  end

  private

  def prepare_date(timestamp)
    timestamp.in_time_zone(@account.time_zone).to_date
  end

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
