class Delivery
  include ActiveModel::Model

  attr_accessor :campaign, :tagged_with, :not_tagged_with
  delegate :account, to: :campaign
  validate :validate_enough_credits

  def save
    return false unless valid?
    DeliveryWorker.perform_async campaign.id, tagged_with, not_tagged_with
  end

  def tags
    account.tags.map(&:name) + account.campaigns.opened_campaign_names
  end

  private

  def validate_enough_credits
    segment = Segment.new account: account,
                          tagged_with: tagged_with,
                          not_tagged_with: not_tagged_with

    if account.credits_exceed?(segment.count)
      errors.add :base, :credits_exceeded
    end
  end
end
