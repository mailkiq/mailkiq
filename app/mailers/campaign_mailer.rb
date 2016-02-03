class CampaignMailer < ActionMailer::Base
  def campaign(campaign_id, subscriber_id)
    campaign = Campaign.find campaign_id
    subscriber = Subscriber.find subscriber_id

    track user: subscriber,
          click: true,
          utm_source: 'mailkiq',
          utm_campaign: campaign.name.parameterize,
          extra: { campaign_id: campaign_id }

    options = {
      to: subscriber.email,
      from: "#{campaign.from_name} <#{campaign.from_email}>",
      subject: campaign.subject,
      delivery_method_options: campaign.account.credentials
    }

    mail(options) do |format|
      format.html { render text: campaign.html_text }
      format.text { render text: campaign.plain_text } if campaign.plain_text?
    end
  end
end
