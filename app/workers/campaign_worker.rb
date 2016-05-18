class CampaignWorker
  include Sidekiq::Worker

  sidekiq_options backtrace: true, retry: 0

  def perform(campaign_id, subscriber_id)
    ActiveRecord::Base.transaction do
      CampaignMailer.new(campaign_id, subscriber_id).deliver!
    end
  rescue Aws::SES::Errors::Throttling => exception
    CampaignWorker.perform_async(campaign_id, subscriber_id)
  rescue Aws::SES::Errors::InvalidParameterValue => exception
    Subscriber.mark_as_wrong_email subscriber_id
  ensure
    Raven.capture_exception(exception) if exception
  end
end
