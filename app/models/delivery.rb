class Delivery
  include ActiveModel::Model

  attr_accessor :account, :campaign, :tagged_with, :not_tagged_with

  def save
    DeliveryWorker.perform_async campaign.id, not_tagged_with
  end

  def tags
    account.tags.map(&:name) +
      account.campaigns.map { |record| "Opened #{record.name}" }
  end
end
