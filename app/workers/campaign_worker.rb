class CampaignWorker
  include Sidekiq::Worker

  sidekiq_options backtrace: true, retry: 3

  def perform(campaign_id, subscriber_id)
    CampaignMailer.campaign(campaign_id, subscriber_id).deliver_now
  rescue Fog::AWS::SES::InvalidParameterError => ex
    if invalid_email_address?(ex.message)
      subscriber = Subscriber.find(subscriber_id)
      subscriber.email.gsub!('@.', '@')
      subscriber.email.gsub!(/\.{2,}/, '.')
      subscriber.update_column :email, subscriber.email
    end
    raise
  end

  private

  def invalid_email_address?(msg)
    msg.include?('Domain starts with dot') ||
      msg.include?('Domain contains dot-dot')
  end
end
