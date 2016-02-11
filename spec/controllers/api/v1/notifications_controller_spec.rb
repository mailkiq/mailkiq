require 'rails_helper'

describe API::V1::NotificationsController, type: :controller do
  describe 'POST /api/v1/notifications' do
    confirm_subscription = { cassette_name: :confirm_subscription }

    context 'confirm subscription', vcr: confirm_subscription do
      let(:account) { Fabricate.build :valid_account }
      let(:notification) do
        JSON.parse File.read('spec/vcr/subscription_confirmation.json')
      end

      before do
        request.headers['X-Amz-Sns-Topic-Arn'] = 'arn:aws:sns:*'
        request.env['RAW_POST_DATA'] = notification.to_json

        allow(Account).to receive(:find).with(1).and_return(account)
        allow_any_instance_of(SNS::MessageVerifier).to receive(:authenticate!)

        post :create, format: :json, token: Token.encode(account_id: 1)
      end

      it { is_expected.to respond_with :success }
      it { is_expected.to use_before_action :validate_amazon_headers }
      it { is_expected.to use_before_action :authenticate! }
      it { expect(assigns(:notification)).to be_subscription_confirmation }
    end

    context 'amazon headers validation' do
      before { post :create, format: :json }
      it { is_expected.to respond_with :unauthorized }
    end
  end
end
