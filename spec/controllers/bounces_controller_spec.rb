require 'rails_helper'

describe BouncesController, type: :controller do
  describe 'POST /bounces', :skip do
    let(:notification) do
      path = Rails.root.join('spec', 'vcr', 'notification.json')
      JSON.parse File.read(path)
    end

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
