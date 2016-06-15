class Delivery
  SCOPES = [OpenedScope, TagScope].freeze

  delegate :processing?, to: :@campaign

  def initialize(campaign, params = {})
    @quota = Quota.new campaign.account
    @campaign = campaign
    @params = params
  end

  def tags
    @campaign.account.tags.map(&:name) + opened_campaign_names
  end

  def valid?
    @campaign.valid? && !@campaign.account_expired? && !@quota.exceed?(count)
  end

  def enqueue
    @campaign.assign_attributes(@params)
    @campaign.enqueue! do
      raise ActiveRecord::RecordInvalid, 'invalid' unless valid?

      @campaign.account.increment! :used_credits, count
      @campaign.recipients_count = count
      @campaign.save!

      DeliveryJob.enqueue @campaign.id
    end
  end

  def push_bulk
    QueJob.push_bulk(chain_scopes.to_sql, @campaign.id)
  end

  def count
    @count ||= chain_scopes.count
  end

  private

  def opened_campaign_names
    names = @campaign.account.campaigns.sent.pluck(:name)
    names.map! { |name| "Opened #{name}" }
  end

  def chain_scopes
    relation = Subscriber.activated.where(account_id: @campaign.account_id)
    SCOPES.each do |klass|
      new_relation = klass.new(relation, @campaign).call
      relation = new_relation if new_relation
    end
    relation
  end
end
