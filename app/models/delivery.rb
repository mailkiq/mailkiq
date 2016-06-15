class Delivery
  SCOPES = [OpenedScope, TagScope].freeze

  def initialize(campaign, params = {})
    @campaign = campaign
    @params = params
    @quota = Quota.new @campaign.account
  end

  def tags
    @campaign.account.tags.map(&:name) + opened_campaign_names
  end

  def valid?
    !@campaign.account_expired? && @campaign.valid? &&
      !@quota.exceed?(chain_queries.count)
  end

  def processing?
    @campaign.queued? || @campaign.sending?
  end

  def enqueue
    @campaign.assign_attributes(@params)
    @campaign.enqueue valid: valid? do
      @campaign.save!
      DeliveryJob.enqueue @campaign.id
    end
  end

  def push_bulk
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
