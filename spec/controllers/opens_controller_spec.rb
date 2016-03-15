require 'rails_helper'

describe OpensController, type: :controller do
  let(:message) { Message.new }
  let(:google_url) { 'http://www.google.com.br' }

  describe 'GET /track/opens/:id' do
    before do
      pixel = Base64.decode64(OpensController::PIXEL)

      expect(message).to receive(:see!).and_call_original
      expect(message).to receive(:save!)
      expect(Message).to receive(:find_by).with(token: 'value')
        .and_return(message)

      expect(controller).to receive(:send_data)
        .with(pixel, type: 'image/gif', disposition: :inline)
        .and_call_original

      get :show, id: 'value'
    end

    it { is_expected.to respond_with :success }
  end
end
