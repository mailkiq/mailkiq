class DeliveryWorker
  include Sidekiq::Worker

  sidekiq_options queue: :critical, retry: false, backtrace: true, dead: true

  def perform(campaign_id, tagged_with, not_tagged_with)
    campaign = Campaign.find campaign_id
    segment = Segment.new account: campaign.account,
                          tagged_with: tagged_with,
                          not_tagged_with: not_tagged_with

    Sidekiq::Client.push_bulk 'queue' => 'campaigns',
                              'class' => CampaignWorker,
                              'args' => segment.jobs(campaign_id: campaign_id)
  end
end
