class Delivery
  delegate :processing?, to: :@campaign
  delegate :tags, :count, to: :@scope

  def initialize(campaign, params = {})
    @scope = ScopeChain.new campaign
    @quota = Quota.new campaign.account
    @campaign = campaign
    @params = params
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
    QueJob.push_bulk(@scope.to_sql, @campaign.id)
  end
end
