class CampaignMailer
  attr_reader :token, :mail

  def initialize(campaign_id, subscriber_id)
    @campaign = Campaign.unscoped.find campaign_id
    @subscriber = Subscriber.find subscriber_id
    @ses = Aws::SES::Client.new(@campaign.account_aws_options)
    @token = SecureRandom.urlsafe_base64(32).gsub(/[\-_]/, '').first(32)
    @mail = build_mail
  end

  def deliver!
    MailerProcessor.new(self).transform!
    response = send_raw_email(mail)
    create_message! response.message_id
    mail
  end

  def utm_params
    { utm_medium: :email,
      utm_source: :mailkiq,
      utm_campaign: @campaign.name.parameterize }
  end

  def subscription_token
    Token.encode(@subscriber.id)
  end

  def interpolations
    {
      first_name: @subscriber.first_name,
      last_name: @subscriber.last_name,
      full_name: @subscriber.name
    }
  end

  private

  def build_mail
    m = Mail::Message.new
    m.mime_version = '1.0'
    m.charset = 'UTF-8'
    m.to = @subscriber.email
    m.from = @campaign.from
    m.subject = @campaign.subject.render!(interpolations)

    if @campaign.plain_text?
      m.text_part = @campaign.plain_text
      m.text_part.charset = 'UTF-8'
    end

    if @campaign.html_text?
      m.html_part = @campaign.html_text
      m.html_part.charset = 'UTF-8'
    end

    m
  end

  def send_raw_email(mail)
    send_opts = {}
    send_opts[:raw_message] = {}
    send_opts[:raw_message][:data] = mail.to_s
    send_opts[:destinations] = mail.destinations
    @ses.send_raw_email(send_opts)
  end

  def create_message!(uuid)
    Message.create! uuid: uuid,
                    token: token,
                    campaign_id: @campaign.id,
                    subscriber_id: @subscriber.id,
                    sent_at: Time.now
  end
end
