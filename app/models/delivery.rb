class Delivery
  SCOPES = [OpenedScope, TagScope].freeze

  def initialize(campaign)
    @campaign = campaign
  end

  def tags
    @campaign.account.tags.map(&:name) + opened_campaign_names
  end

  def call(params = {})
    return false unless @campaign.valid?

    if @campaign.account.quota_exceed? chain_queries.count
      @campaign.errors.add :base, :quota_exceeded
      return false
    end

    DeliveryJob.enqueue @campaign.id if @campaign.update params
  end

  def deliver!
    QueJob.push_bulk(chain_queries.to_sql, @campaign.id)
  end

  private

  def opened_campaign_names
    names = @campaign.account.campaigns.sent.pluck(:name)
    names.map! { |name| "Opened #{name}" }
  end

  def chain_queries
    relation = Subscriber.activated.where(account_id: @campaign.account_id)
    SCOPES.each do |klass|
      new_relation = klass.new(relation, @campaign).call
      relation = new_relation if new_relation
    end
    relation
  end
end
