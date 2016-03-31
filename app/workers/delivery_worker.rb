class DeliveryWorker
  include Sidekiq::Worker

  sidekiq_options queue: :deliveries, backtrace: true, retry: 0

  def perform(campaign_id, tagged_with, not_tagged_with)
    campaign = Campaign.find campaign_id
    segment = Segment.new account: campaign.account,
                          tagged_with: tagged_with,
                          not_tagged_with: not_tagged_with

    campaign.queue.pause

    jobs = segment.jobs_for(campaign_id: campaign_id)

    campaign.queue.push_bulk(jobs)
    campaign.update_columns recipients_count: jobs.size, sent_at: Time.now
    campaign.queue.unpause
  end
end
