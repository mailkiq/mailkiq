class DeliveryJob < ApplicationJob
  @retry_interval = proc { 1.year.to_i }
  @priority = 1

  def run(campaign_id)
    campaign = Campaign.unsent.find campaign_id
    campaign.with_lock do
      delivery = Delivery.new campaign
      delivery.deliver!
    end
  end
end
