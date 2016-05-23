class Delivery
  QUERIES = [OpenedScope, TagScope].freeze

  include ActiveModel::Model

  attr_accessor :campaign, :tagged_with, :not_tagged_with
  delegate :account, to: :campaign
  delegate :quota_exceed?, to: :account
  validate :validate_enough_credits

  def tagged_with=(value)
    @tagged_with = Array(value)
  end

  def not_tagged_with=(value)
    @not_tagged_with = Array(value)
  end

  def opened_campaign_names
    account.campaigns.sent.pluck(:name).map { |name| "Opened #{name}" }
  end

  def tags
    account.tags.map(&:name) + opened_campaign_names
  end

  def deliver!
    QueJob.push_bulk(chain_queries.to_sql, campaign.id)
  end

  def save
    return false unless valid?
    DeliveryJob.enqueue campaign.id, tagged_with, not_tagged_with
  end

  private

  def chain_queries
    relation = Subscriber.actived.where(account_id: account.id)
    QUERIES.each do |klass|
      new_relation = klass.new(relation, tagged_with, not_tagged_with).call
      relation = new_relation if new_relation
    end
    relation
  end

  def validate_enough_credits
    errors.add :base, :quota_exceeded if quota_exceed?(chain_queries.count)
  end
end
