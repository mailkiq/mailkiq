class FinishJob < ApplicationJob
  @retry_interval = proc { 1.year.to_i }

  def run(campaign_id)
    campaign = Campaign.sending.find campaign_id
    campaign.finish! do
      destroy
    end
  end
end
