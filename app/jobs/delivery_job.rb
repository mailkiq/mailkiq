class DeliveryJob < ApplicationJob
  @retry_interval = proc { 1.year.to_i }
  @priority = 1

  def run(campaign_id)
    campaign = Campaign.queued.find campaign_id
    campaign.deliver! do
      delivery = Delivery.new campaign
      delivery.push_bulk
    end
  end
end
