require 'rails_helper'
require 'signature'

RSpec.describe TracksController, type: :request do
  let(:message) { Message.new }
  let(:event) { Fabricate.build :message_event }

  before do
    expect(message).to receive(:save!)
    expect(Campaign).to receive(:increment_counter).at_least(:once)
    expect(Message).to receive(:find_by).with(token: message.token)
      .and_return(message)
  end

  describe 'GET /track/open/:id' do
    it 'responds with success' do
      get open_path(message.token)

      expect(response.content_type).to eq Mime[:gif]
      expect(response).to have_http_status :success
    end
  end

  describe 'GET /track/click/:id' do
    it 'responds with success' do
      get click_path(message.token),
          params: { signature: event.signature, url: event.url }

      expect(response).to have_http_status :redirect
      expect(response).to redirect_to event.url
    end
  end
end
