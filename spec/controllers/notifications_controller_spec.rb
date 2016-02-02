require 'rails_helper'

describe NotificationsController, type: :controller do
  describe 'POST /notifications' do
    confirm_subscription = { cassette_name: :confirm_subscription }

    context 'confirm subscription', vcr: confirm_subscription do
      let(:account) { Fabricate.build :valid_account }
      let(:notification) do
        JSON.parse File.read('spec/vcr/subscription_confirmation.json')
      end

      before do
        request.env['RAW_POST_DATA'] = notification.to_json

        allow(Account).to receive(:find).with(1).and_return(account)
        allow_any_instance_of(SNS::MessageVerifier).to receive(:authenticate!)

        post :create, format: :json, token: AuthToken.encode(account_id: 1)
      end

      it { is_expected.to respond_with :success }
      it { expect(assigns(:json)).to eq(notification) }
      it { expect(assigns(:notification)).to be_subscription_confirmation }
    end
  end
end
