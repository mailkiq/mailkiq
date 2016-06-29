require_dependency 'pony'

class CampaignMailer
  def initialize(campaign_id, subscriber_id)
    @campaign = Campaign.unscoped.find campaign_id
    @subscriber = Subscriber.find subscriber_id
    @message = Message.new campaign: @campaign, subscriber: @subscriber
    @ses = Aws::SES::Client.new(@campaign.account.aws_options)
  end

  def deliver!
    mail = Pony.build_mail(mail_options)
    resp = send_raw_email(mail)
    @message.save_with_uuid! resp.message_id
    mail
  end

  private

  def send_raw_email(mail)
    send_opts = {}
    send_opts[:raw_message] = {}
    send_opts[:raw_message][:data] = mail.to_s
    send_opts[:destinations] = mail.destinations
    @ses.send_raw_email(send_opts)
  end

  def mail_options
    renderer = MessageRenderer.new(@message).render!
    mail_opts = {}
    mail_opts[:to] = @subscriber.email
    mail_opts[:from] = @campaign.from
    mail_opts[:subject] = @campaign.subject.render!(@subscriber.interpolations)
    mail_opts[:html_body] = renderer.to_html if @campaign.html_text?
    mail_opts[:body] = renderer.to_text if @campaign.plain_text?
    mail_opts
  end
end
