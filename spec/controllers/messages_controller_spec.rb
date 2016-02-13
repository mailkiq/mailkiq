require 'rails_helper'

describe MessagesController, type: :controller do
  let(:message) { Message.new }
  let(:google_url) { 'http://www.google.com.br' }

  before do
    expect(message).to receive(:save!)
    expect(Message).to receive(:find_by).with(token: 'value')
      .and_return(message)
  end

  describe 'GET /messages/:id/open' do
    before { get :open, id: 'value' }

    it { expect(message.opened_at).to_not be_nil }
    it { is_expected.to use_before_action :set_message }
    it { is_expected.to respond_with :success }
  end

  describe 'GET /messages/:id/click' do
    before do
      signature = Signature.hexdigest(google_url)
      expect(Signature).to receive(:secure_compare).and_call_original
      get :click, id: 'value', signature: signature, url: google_url
    end

    it { expect(message.clicked_at).to_not be_nil }
    it { expect(message.opened_at).to eq(message.clicked_at) }
    it { is_expected.to use_before_action :set_message }
    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to(google_url) }
  end
end
