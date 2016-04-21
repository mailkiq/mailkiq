class Delivery
  include ActiveModel::Model

  attr_accessor :campaign, :tagged_with, :not_tagged_with
  delegate :account, to: :campaign
  delegate :credits_exceeded?, to: :account
  validate :validate_enough_credits

  def save
    return false unless valid?
    Resque.enqueue DeliveryWorker, campaign.id, tagged_with, not_tagged_with
  end

  def opened_campaign_names
    account.campaigns.sent.pluck(:name).map { |name| "Opened #{name}" }
  end

  def tags
    account.tags.map(&:name) + opened_campaign_names
  end

  def jobs
    segment.jobs_for campaign.id
  end

  private

  def segment
    Segment.new account: account, tagged_with: tagged_with,
                not_tagged_with: not_tagged_with
  end

  def validate_enough_credits
    errors.add :base, :credits_exceeded if credits_exceed?(segment.count)
  end
end
