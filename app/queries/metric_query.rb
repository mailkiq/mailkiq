class MetricQuery
  def self.sent_by_account(account)
    Message.where(campaign_id: account.campaigns.select(:id))
      .group_by_day(:sent_at, dates: true, time_zone: account.time_zone)
      .count
  end
end
