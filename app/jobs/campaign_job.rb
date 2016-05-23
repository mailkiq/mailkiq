class CampaignJob < Que::Job
  @retry_interval = proc { 1.year.to_i }

  def run(campaign_id, subscriber_id)
    ActiveRecord::Base.transaction do
      CampaignMailer.new(campaign_id, subscriber_id).deliver!
    end
  rescue Aws::SES::Errors::Throttling => exception
    CampaignJob.enqueue(campaign_id, subscriber_id)
  rescue Aws::SES::Errors::InvalidParameterValue => exception
    Subscriber.mark_as_wrong_email subscriber_id
  ensure
    Raven.capture_exception(exception) if exception
  end
end
