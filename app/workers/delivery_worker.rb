class DeliveryWorker
  include Sidekiq::Worker

  sidekiq_options queue: :deliveries, backtrace: true, retry: 0

  def perform(campaign_id, tagged_with, not_tagged_with)
    campaign = Campaign.find campaign_id
    delivery = Delivery.new(
      campaign: campaign,
      tagged_with: tagged_with,
      not_tagged_with: not_tagged_with
    )

    delivery.deliver!
  end
end
