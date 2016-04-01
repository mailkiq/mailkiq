class Delivery
  include ActiveModel::Model

  attr_accessor :account, :campaign, :tagged_with, :not_tagged_with

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
    segment = Segment.new(
      account: campaign.account,
      tagged_with: tagged_with,
      not_tagged_with: not_tagged_with
    )

    unless account.exceeded_credits?(segment.count)
      record.errors.add :base, :exceeded_credits
    end
  end
end
