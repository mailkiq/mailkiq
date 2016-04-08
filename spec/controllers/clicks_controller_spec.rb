require 'rails_helper'

describe ClicksController, type: :controller do
  let(:message) { Message.new }
  let(:google_url) { 'http://www.google.com.br' }

  describe 'GET /track/clicks/:id' do
    before do
      expect(message).to receive(:click!).and_call_original
      expect(message).to receive(:save!)

      expect(Message).to receive(:find_by).with(token: 'value')
        .and_return(message)
      expect(Campaign).to receive(:increment_counter)
        .with(:unique_clicks_count, message.id)

      expect(Signature).to receive(:secure_compare).and_call_original

      signature = Signature.hexdigest(google_url)

      get :show, id: 'value', signature: signature, url: google_url
    end

    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to(google_url) }
  end
end
