require 'rails_helper'

describe API::V1::NotificationsController, type: :controller do
  describe 'POST /api/v1/notifications' do
    let(:account) { Fabricate.build :valid_account }

    confirm_subscription = { cassette_name: :confirm_subscription }

    context 'confirm subscription', vcr: confirm_subscription do
      let(:sns) { assigns :sns }

      before do
        mock!
        send_raw_json! 'spec/vcr/subscription_confirmation.json'
        post :create, format: :json, token: Token.encode(account_id: 1)
      end

      it { is_expected.to filter_param :token }
      it { is_expected.to respond_with :success }
      it { is_expected.to use_before_action :validate_amazon_headers }
      it { is_expected.to use_before_action :authenticate! }
      it { expect(sns).to be_subscription_confirmation }
    end

    context 'insert new notification on the database' do
      before do
        mock!
        send_raw_json! 'spec/vcr/bounce.json'

        expect(Notification).to receive(:create!).with an_instance_of(Hash)
        expect(account).to receive_message_chain(:subscribers, :where, :update_all)
          .with an_instance_of(Hash)

        post :create, format: :json, token: Token.encode(account_id: 1)
      end

      it { is_expected.to filter_param :token }
      it { is_expected.to respond_with :success }
      it { is_expected.to use_before_action :validate_amazon_headers }
      it { is_expected.to use_before_action :authenticate! }
    end

    context 'validate amazon headers' do
      before { post :create, format: :json }
      it { is_expected.to respond_with :unauthorized }
    end

    def mock!
      request.headers['X-Amz-Sns-Topic-Arn'] = 'arn:aws:sns:*'
      expect(Account).to receive(:find).with(1).and_return(account)
      expect_any_instance_of(Fog::AWS::SNS::MessageVerifier).to receive(:authenticate!)
    end

    def send_raw_json!(path)
      request.env['RAW_POST_DATA'] = File.read(path)
    end
  end
end
