class CampaignWorker
  include Sidekiq::Worker

  sidekiq_options backtrace: true, retry: 0

  def perform(campaign_id, subscriber_id)
    ActiveRecord::Base.transaction do
      CampaignMailer.campaign(campaign_id, subscriber_id).deliver_now
    end
  rescue Aws::SES::Errors::Throttling => exception
    CampaignWorker.perform_async(campaign_id, subscriber_id)
  rescue Aws::SES::Errors::InvalidParameterValue => exception
    Subscriber.where(id: subscriber_id)
              .update_all(state: Subscriber.states[:unconfirmed])
  ensure
    Raven.capture_exception(exception) if exception
  end
end
