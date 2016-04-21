class CampaignWorker
  include Sidekiq::Worker

  sidekiq_options backtrace: true, retry: 0

  def perform(campaign_id, subscriber_id)
    ActiveRecord::Base.transaction do
      CampaignMailer.campaign(campaign_id, subscriber_id).deliver_now
    end
  rescue Aws::SES::Errors::InvalidParameterValue => ex
    Raven.capture_exception(ex)
    state = Subscriber.states[:unconfirmed]
    Subscriber.where(id: subscriber_id).update_all state: state
  end
end
