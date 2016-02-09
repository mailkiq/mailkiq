class DeliveryWorker
  include Sidekiq::Worker

  sidekiq_options queue: :critical, backtrace: true

  def perform(campaign_id, not_tagged_with)
    campaign = Campaign.find campaign_id
    segment = Segment.new account: campaign.account,
                          not_tagged_with: not_tagged_with

    Sidekiq::Client.push_bulk 'queue' => campaign.queue_name,
                              'class' => CampaignWorker,
                              'args' => segment.jobs(campaign_id: campaign_id)
  end
end
