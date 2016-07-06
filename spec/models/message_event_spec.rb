require 'rails_helper'

RSpec.describe MessageEvent, type: :model do
  let(:message) { Message.new campaign_id: 10 }
  let(:event) { Fabricate.build :message_event }

  subject { described_class.new message, event.to_h }

  before do
    expect(Campaign).to receive(:increment_counter)
      .with(:unique_opens_count, message.campaign_id)
    expect(message).to receive(:save!)
  end

  describe '#open!' do
    it 'sets some attributes with the given request object' do
      subject.open!

      expect(message.opened_at).not_to be_nil
      expect(message.referer).to eq(event.referer)
      expect(message.ip_address).to eq(event.remote_ip)
      expect(message.user_agent).to eq(event.user_agent)
    end
  end

  describe '#click!' do
    it 'sets some attributes with the given request object' do
      expect(Campaign).to receive(:increment_counter)
        .with(:unique_clicks_count, message.campaign_id)

      subject.click!

      expect(message.opened_at).not_to be_nil
      expect(message.clicked_at).to eq(message.opened_at)
      expect(message.referer).to eq(event.referer)
      expect(message.ip_address).to eq(event.remote_ip)
      expect(message.user_agent).to eq(event.user_agent)
    end
  end
end
