class CampaignMailer < ActionMailer::Base
  def campaign(campaign_id, subscriber_id)
    campaign = Campaign.find campaign_id
    subscriber = Subscriber.find subscriber_id

    track subscriber: subscriber,
          click: true,
          utm_source: 'mailkiq',
          utm_campaign: campaign.name.parameterize,
          extra: { campaign_id: campaign_id }

    subject = Template.render campaign.subject,
                              first_name: subscriber.first_name,
                              last_name: subscriber.last_name,
                              full_name: subscriber.name

    options = {
      to: subscriber.email,
      from: campaign.sender,
      subject: subject,
      delivery_method: :ses,
      delivery_method_options: campaign.credentials
    }

    response = mail(options) do |format|
      format.html { render text: campaign.html_text }
      format.text { render text: campaign.plain_text } if campaign.plain_text?
    end

    # Note: Amazon SES overrides any Message-ID header you provide.
    # This is the reason we're reusing the message_id variable here.
    # Clever way to pass data to SES::Base instance.
    response.message_id = headers['Ahoy-Message-Id'].to_s
    response
  end
end
