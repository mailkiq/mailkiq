class Delivery
  include ActiveModel::Model
  attr_accessor :campaign, :email

  def save
    subscriber = Subscriber.find_by! email: email

    CampaignMailer.delay(queue: campaign.queue_name)
      .campaign(campaign.id, subscriber.id)
  end
end
