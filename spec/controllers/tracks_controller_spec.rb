require 'rails_helper'

describe TracksController, type: :controller do
  let(:message) { Message.new }
  let(:google_url) { 'http://www.google.com.br' }

  before do
    allow(message).to receive(:save!)
    allow(Campaign).to receive(:increment_counter)
      .with(:unique_opens_count, message.id)
    allow(Campaign).to receive(:increment_counter)
      .with(:unique_clicks_count, message.id)

    expect(Message).to receive(:find_by).with(token: 'zzz').and_return(message)
  end

  describe '#open' do
    before do
      expect(controller).to receive(:send_data)
        .with(DECODED_PIXEL, type: 'image/gif', disposition: :inline)
        .and_call_original

      get :open, id: 'zzz'
    end

    it { is_expected.to use_before_action :set_message }
    it { is_expected.to respond_with :success }
  end

  describe '#click' do
    before do
      signature = Signature.hexdigest(google_url)
      get :click, id: 'zzz', signature: signature, url: google_url
    end

    it { is_expected.to use_before_action :set_message }
    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to(google_url) }
  end
end
