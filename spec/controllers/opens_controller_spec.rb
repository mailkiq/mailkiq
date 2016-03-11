require 'rails_helper'

describe OpensController, type: :controller do
  let(:message) { Message.new }
  let(:google_url) { 'http://www.google.com.br' }

  describe 'GET /track/opens/:id' do
    before do
      expect(message).to receive(:save!)
      expect(Message).to receive(:find_by).with(token: 'value')
        .and_return(message)

      get :show, id: 'value'
    end

    it { expect(message.opened_at).to_not be_nil }
    it { is_expected.to respond_with :success }
  end
end
