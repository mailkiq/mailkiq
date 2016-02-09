class Segment
  attr_reader :account, :not_tagged_with

  def initialize(options = {})
    @account = options[:account]
    @not_tagged_with = options[:not_tagged_with]
  end

  def jobs(campaign_id:)
    subscriber_ids = subscribers.pluck(:id)
    subscriber_ids.map! { |subscriber_id| [campaign_id, subscriber_id] }
  end

  private

  def subscribers
    if not_tagged_with.present?
      Subscribers::UnopenedQuery.new(untagged_campaign.id).call
    else
      account.subscribers
    end
  end

  def untagged_campaign
    Campaign.find_by! name: not_tagged_with.gsub('Opened ', '')
  end
end
