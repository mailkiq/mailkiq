class CampaignMailer
  attr_reader :token, :mail

  def initialize(campaign_id, subscriber_id)
    @campaign = Campaign.find campaign_id
    @subscriber = Subscriber.find subscriber_id
    @ses = Aws::SES::Client.new(@campaign.account_aws_options)
    @token = SecureRandom.urlsafe_base64(32).gsub(/[\-_]/, '').first(32)
    @mail = Mail::Message.new
    set_mail_attributes
  end

  def deliver!
    MailerProcessor.new(self).transform!
    response = send_raw_email(mail)
    create_message! response.message_id
  end

  def utm_params
    { utm_medium: :email,
      utm_source: :mailkiq,
      utm_campaign: @campaign.name.parameterize }
  end

  def subscription_token
    Token.encode(@subscriber.id)
  end

  private

  def set_mail_attributes
    mail.to = @subscriber.email
    mail.mime_version = '1.0'
    mail.charset = 'UTF-8'
    mail.from = @campaign.from
    mail.subject = @campaign.subject.render! @subscriber.interpolations
    mail.text_part = @campaign.plain_text if @campaign.plain_text?
    mail.html_part = @campaign.html_text if @campaign.html_text?
  end

  def send_raw_email(mail)
    send_opts = {}
    send_opts[:raw_message] = {}
    send_opts[:raw_message][:data] = mail.to_s
    send_opts[:destinations] = mail.destinations
    @ses.send_raw_email(send_opts)
  end

  def create_message!(uuid)
    Message.create!(
      uuid: uuid,
      token: token,
      campaign_id: @campaign.id,
      subscriber_id: @subscriber.id,
      sent_at: Time.now
    )
  end
end
