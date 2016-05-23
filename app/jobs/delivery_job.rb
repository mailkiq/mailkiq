class DeliveryJob < Que::Job
  @retry_interval = proc { 1.year.to_i }
  @priority = 1

  def run(campaign_id, tagged_with, not_tagged_with)
    campaign = Campaign.unsent.find campaign_id
    campaign.with_lock do
      delivery = Delivery.new(
        campaign: campaign,
        tagged_with: tagged_with,
        not_tagged_with: not_tagged_with
      )

      delivery.deliver!
    end
  end
end
