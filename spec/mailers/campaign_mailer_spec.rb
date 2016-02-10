require 'rails_helper'

describe CampaignMailer, type: :mailer do
  describe '#campaign', vcr: { cassette_name: :send_raw_email } do
    let(:account) { Fabricate.build :valid_account }
    let(:campaign) { Fabricate.build :campaign, id: rand(10), account: account }
    let(:subscriber) { Fabricate.build :subscriber, id: rand(10) }

    before do
      expect(Campaign).to receive(:find).with(campaign.id)
        .and_return(campaign)
      expect(Subscriber).to receive(:find).with(subscriber.id)
        .and_return(subscriber)

      ahoy_message = Message.new
      expect_any_instance_of(Message).to receive(:save)
      expect(Message).to receive(:find).and_return(ahoy_message)
      expect(ahoy_message).to receive(:update) do |attributes|
        ahoy_message.assign_attributes(attributes)
      end
    end

    it 'deliver campaign to the subscriber' do
      message = CampaignMailer.campaign(campaign.id, subscriber.id).deliver_now

      expect(message.from).to include(campaign.from_email)
      expect(message.to).to include(subscriber.email)
      expect(message.subject).to eq(campaign.subject)
      expect(message.delivery_method).to be_instance_of SES::Base
      expect(message.delivery_method.settings).to eq(account.credentials)
      expect(message.to_s).to match(/open.gif/)
    end
  end
end
