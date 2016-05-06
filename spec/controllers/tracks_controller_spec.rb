require 'rails_helper'

describe TracksController, type: :controller do
  let(:message) { Message.new }
  let(:google_url) { 'http://www.google.com.br' }

  describe '#open' do
    before do
      pixel = Base64.decode64(TracksController::PIXEL)

      expect(message).to receive(:see!).and_call_original
      expect(message).to receive(:save!)

      expect(Message).to receive(:find_by).with(token: 'value')
        .and_return(message)
      expect(Campaign).to receive(:increment_counter)
        .with(:unique_opens_count, message.id)

      expect(controller).to receive(:send_data)
        .with(pixel, type: 'image/gif', disposition: :inline)
        .and_call_original

      get :open, id: 'value'
    end

    it { is_expected.to respond_with :success }
  end

  describe '#click' do
    before do
      expect(message).to receive(:click!).and_call_original
      expect(message).to receive(:save!)

      expect(Message).to receive(:find_by).with(token: 'value')
        .and_return(message)
      expect(Campaign).to receive(:increment_counter)
        .with(:unique_clicks_count, message.id)

      expect(Signature).to receive(:secure_compare).and_call_original

      signature = Signature.hexdigest(google_url)

      get :click, id: 'value', signature: signature, url: google_url
    end

    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to(google_url) }
  end
end
