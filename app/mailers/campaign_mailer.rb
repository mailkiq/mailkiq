require_dependency 'email_interceptor'

class CampaignMailer < ActionMailer::Base
  include ActionView::Helpers::AssetTagHelper

  after_action :transform!
  attr_reader :subscriber, :list_unsubscribe_url

  def campaign(campaign_id, subscriber_id)
    @campaign = Campaign.find campaign_id
    @subscriber = Subscriber.find subscriber_id
    @list_unsubscribe_url = unsubscribe_url(token: @subscriber.subscription_token)

    headers['List-Unsubscribe'] = "<#{@list_unsubscribe_url}>"

    options = {
      to: @subscriber.email,
      from: @campaign.from,
      subject: @campaign.subject.render!(@subscriber.interpolations),
      delivery_method: :ses,
      delivery_method_options: @campaign.account_credentials
    }

    mail(options) do |format|
      format.html { render text: @campaign.html_text } if @campaign.html_text?
      format.text { render text: @campaign.plain_text } if @campaign.plain_text?
    end
  end

  def _campaign
    @campaign
  end

  private

  def transform!
    utm_params = {
      utm_medium: 'email',
      utm_source: 'mailkiq',
      utm_campaign: @campaign.name.parameterize
    }

    EmailInterceptor.new(self, utm_params).transform!
  end
end
