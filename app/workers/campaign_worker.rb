class CampaignWorker
  include Sidekiq::Worker

  sidekiq_options backtrace: true, retry: 0

  def perform(campaign_id, subscriber_id)
    ActiveRecord::Base.transaction do
      CampaignMailer.campaign(campaign_id, subscriber_id).deliver_now
    end
  end

  private

  def invalid_email_address?(msg)
    msg.include?('Domain starts with dot') ||
      msg.include?('Domain contains dot-dot')
  end
end
