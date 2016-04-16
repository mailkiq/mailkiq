require 'rails_helper'

describe API::V1::NotificationsController, type: :controller do
  describe '#create' do
    let(:account) { Fabricate.build :valid_account }

    context 'confirmation', vcr: { cassette_name: :confirm_subscription } do
      before do
        expect_sign_in_as(account)
        expect_any_instance_of(NotificationManager).to receive(:confirm)

        request.headers['X-Amz-Sns-Topic-Arn'] = account.aws_topic_arn
        request.env['RAW_POST_DATA'] = fixture(:subscription_confirmation)

        post :create, format: :json, api_key: account.api_key
      end

      it { is_expected.to filter_param :api_key }
      it { is_expected.to respond_with :success }
      it { is_expected.to use_before_action :authenticate! }
      it { is_expected.to use_before_action :validate_amazon_headers }
    end

    context 'bounce' do
      before do
        expect_sign_in_as(account)
        expect_any_instance_of(NotificationManager).to receive(:create!)

        request.headers['X-Amz-Sns-Topic-Arn'] = account.aws_topic_arn
        request.env['RAW_POST_DATA'] = fixture(:bounce)

        post :create, format: :json, api_key: account.api_key
      end

      it { is_expected.to filter_param :api_key }
      it { is_expected.to respond_with :success }
      it { is_expected.to use_before_action :authenticate! }
      it { is_expected.to use_before_action :validate_amazon_headers }
    end

    context 'headers validation' do
      before do
        expect(controller).to receive(:current_account).and_return(nil)
        post :create, format: :json
      end

      it { is_expected.to use_before_action :authenticate! }
      it { is_expected.to use_before_action :validate_amazon_headers }
      it { is_expected.to respond_with :unauthorized }
      it { expect(response.content_type).to eq Mime::JSON }
    end
  end
end
