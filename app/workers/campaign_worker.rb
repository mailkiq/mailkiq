class CampaignWorker
  include Sidekiq::Worker

  sidekiq_options backtrace: true

  def perform(campaign_id, subscriber_id)
    CampaignMailer.campaign(campaign_id, subscriber_id).deliver_now
  end
end
