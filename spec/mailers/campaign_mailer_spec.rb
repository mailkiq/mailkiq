require 'rails_helper'

describe CampaignMailer, type: :mailer do
  describe '#campaign', vcr: { cassette_name: :send_raw_email } do
    let(:account) { Fabricate.build :valid_account }
    let(:campaign) { Fabricate.build :campaign, id: rand(10), account: account }
    let(:subscriber) { Fabricate.build :subscriber, id: rand(10) }

    before do
      now = Time.now
      expect(Time).to receive(:now).at_least(:once).and_return(now)

      message = Fabricate.build :message
      message.assign_attributes campaign_id: campaign.id,
                                subscriber_id: subscriber.id,
                                sent_at: now

      expect(Campaign).to receive(:find).with(campaign.id)
        .and_return(campaign)
      expect(Subscriber).to receive(:find).with(subscriber.id)
        .and_return(subscriber)

      expect_any_instance_of(EmailInterceptor).to receive(:generate_token)
        .and_return(message[:token])

      expect(Message).to receive(:create!)
        .with(
          uuid: message.uuid,
          token: message.token,
          campaign_id: message.campaign_id,
          subscriber_id: message.subscriber_id,
          sent_at: message.sent_at
        ).and_return(message)
    end

    it 'deliver campaign to the subscriber' do
      message = CampaignMailer.campaign(campaign.id, subscriber.id).deliver_now
      list_unsubscribe_url = unsubscribe_url(subscriber.subscription_token)

      expect(message.header['List-Unsubscribe'].value)
        .to eq("<#{list_unsubscribe_url}>")

      expect(message.from).to include(campaign.from_email)
      expect(message.to).to include(subscriber.email)
      expect(message.subject).to eq(campaign.subject)
      expect(message.delivery_method).to be_instance_of Fog::AWS::SES::Base
      expect(message.delivery_method.settings).to eq(account.credentials)
      expect(message.body.raw_source).to include(list_unsubscribe_url)
    end
  end
end
