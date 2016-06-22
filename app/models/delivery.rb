require_dependency 'query'

class Delivery
  delegate :processing?, to: :@campaign
  delegate :tags, :count, to: :@scope

  def initialize(campaign)
    @scope = ScopeChain.new campaign
    @quota = Quota.new campaign.account
    @campaign = campaign
  end

  def enqueue!(params = {})
    @campaign.enqueue! do
      @campaign.assign_attributes params

      insufficient_credits! if @quota.exceed? count

      @campaign.recipients_count = count
      @campaign.save!
      @quota.use! count

      DeliveryJob.enqueue @campaign.id
    end
  end

  def deliver!
    @campaign.deliver! do
      push_bulk
      FinishJob.enqueue @campaign.id
      yield if block_given?
    end
  end

  def delete
    ActiveRecord::Base.connection.execute <<-SQL.squish!, 'Delete Campaign Jobs'
      DELETE FROM que_jobs WHERE job_class = 'CampaignJob'
         AND args::text ILIKE '[#{@campaign.id},%'
    SQL
  end

  private

  def insufficient_credits!
    @campaign.errors.add :base, :insufficient_credits
    raise ActiveRecord::RecordInvalid, @campaign
  end

  def push_bulk
    Query.execute :queue_jobs, with: @scope.to_sql, campaign_id: @campaign.id
  end
end
