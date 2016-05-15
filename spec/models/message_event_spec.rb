require 'rails_helper'

describe MessageEvent, type: :model do
  let(:message) { Message.new campaign_id: 10 }
  let(:params) do
    request = ActionController::TestRequest.new

    {
      referer: request.referer,
      remote_ip: request.remote_ip,
      user_agent: request.user_agent,
      signature: request.params[:signature].to_s,
      url: request.params[:url].to_s
    }
  end

  subject { described_class.new message, params }

  before do
    expect(Campaign).to receive(:increment_counter)
      .with(:unique_opens_count, message.campaign_id)
    expect(message).to receive(:save!)
  end

  describe '#open!' do
    it 'sets some attributes with the given request object' do
      subject.open!

      expect(message.opened_at).not_to be_nil
      expect(message.referer).to eq(params[:referer])
      expect(message.ip_address).to eq(params[:ip_address])
      expect(message.user_agent).to eq(params[:user_agent])
    end
  end

  describe '#click!' do
    it 'sets some attributes with the given request object' do
      expect(Campaign).to receive(:increment_counter)
        .with(:unique_clicks_count, message.campaign_id)

      subject.click!

      expect(message.opened_at).not_to be_nil
      expect(message.clicked_at).to eq(message.opened_at)
      expect(message.referer).to eq(params[:referer])
      expect(message.ip_address).to eq(params[:remote_ip])
      expect(message.user_agent).to eq(params[:user_agent])
    end
  end
end
