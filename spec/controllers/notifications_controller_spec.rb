require 'rails_helper'

describe NotificationsController, type: :controller do
  describe 'POST /bounces' do
    let(:notification) { JSON.parse File.read('spec/vcr/notification.json') }

    before do
      request.env['RAW_POST_DATA'] = notification.to_json

      allow(User).to receive(:where)
        .with(email: ['romecosta@yahoo.com'])
        .and_call_original

      post :bounces, format: :json
    end

    it { is_expected.to respond_with :success }
  end
end
