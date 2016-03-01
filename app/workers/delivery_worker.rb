class DeliveryWorker
  include Sidekiq::Worker

  sidekiq_options queue: :critical, backtrace: true, retry: 0

  def perform(campaign_id, tagged_with, not_tagged_with)
    campaign = Campaign.find campaign_id
    segment = Segment.new account: campaign.account,
                          tagged_with: tagged_with,
                          not_tagged_with: not_tagged_with

    queue = Sidekiq::Queue[campaign.queue_name]
    queue.pause

    Sidekiq::Client.push_bulk(
      'queue' => campaign.queue_name,
      'class' => CampaignWorker,
      'args'  => segment.jobs_for(campaign_id: campaign_id)
    )

    campaign.update_column :recipients_count, queue.size

    queue.unpause
  end
end
