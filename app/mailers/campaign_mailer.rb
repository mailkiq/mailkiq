class CampaignMailer < ActionMailer::Base
  after_action :interpolate!

  def campaign(campaign_id, subscriber_id)
    @campaign = Campaign.find campaign_id
    @subscriber = Subscriber.find subscriber_id

    track subscriber: @subscriber,
          click: true,
          utm_source: 'mailkiq',
          utm_campaign: @campaign.name.parameterize,
          extra: { campaign_id: campaign_id }

    options = {
      to: @subscriber.email,
      from: @campaign.sender,
      subject: @campaign.subject.render!(@subscriber.interpolations),
      delivery_method: :ses,
      delivery_method_options: @campaign.credentials
    }

    response = mail(options) do |format|
      format.html { render text: @campaign.html_text } if @campaign.html_text?
      format.text { render text: @campaign.plain_text } if @campaign.plain_text?
    end

    # Note: Amazon SES overrides any Message-ID header you provide.
    # This is the reason we're reusing the message_id variable here.
    # Clever way to pass data to SES::Base instance.
    response.message_id = headers['Ahoy-Message-Id'].to_s
    response
  end

  private

  def interpolate!
    token = Token.encode(@subscriber.id)
    unsubscribe_url = unsubscribe_subscription_url(token)

    parts = message.parts.any? ? message.parts : [message]
    parts.each do |part|
      part.body.raw_source.gsub!(/%unsubscribe_url%/i, unsubscribe_url)
    end
  end
end
