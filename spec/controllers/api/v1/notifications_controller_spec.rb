require 'rails_helper'

describe API::V1::NotificationsController, type: :controller do
  describe 'POST /api/v1/notifications' do
    let(:account) { Fabricate.build :valid_account }

    confirm_subscription = { cassette_name: :confirm_subscription }

    context 'confirm subscription', vcr: confirm_subscription do
      let(:subscription_confirmation) { fixture :subscription_confirmation }
      let(:sns) { assigns :sns }

      before do
        mock!
        request.env['RAW_POST_DATA'] = subscription_confirmation.to_json
        post :create, format: :json, api_key: account.api_key
      end

      it { is_expected.to filter_param :token }
      it { is_expected.to respond_with :success }
      it { is_expected.to use_before_action :authenticate! }
      it { expect(sns).to be_subscription_confirmation }
    end

    context 'insert new notification on the database' do
      let(:bounce) { fixture :bounce }
      let(:sns) { Fog::AWS::SNS::Notification.new bounce }

      before do
        mock!
        request.env['RAW_POST_DATA'] = bounce.to_json

        expect(account)
          .to receive_message_chain(:subscribers, :where, :update_all)
          .with(state: Subscriber.states[:bounced])

        expect(Message).to receive_message_chain(:where, :pluck, :first)
          .and_return(1)

        expect(Notification).to receive(:create!).with(
          message_id: 1,
          type: sns.message.type.downcase,
          data: sns.data.as_json
        )

        post :create, format: :json, api_key: account.api_key
      end

      it { is_expected.to filter_param :token }
      it { is_expected.to respond_with :success }
      it { is_expected.to use_before_action :authenticate! }

      it 'parse timestamp correctly' do
        message = assigns(:sns).message
        bounce_timestamp = message.bounce.timestamp
        mail_timestamp = message.mail.timestamp

        expect(bounce_timestamp).to be_utc
        expect(bounce_timestamp.utc_offset).to be_zero
        expect(bounce_timestamp.to_date).to eq '2016-02-02'.to_date

        expect(mail_timestamp).to be_utc
        expect(mail_timestamp.utc_offset).to be_zero
        expect(mail_timestamp.to_date).to eq '2016-02-02'.to_date
      end
    end

    context 'validate amazon headers' do
      before { post :create, format: :json }
      it { is_expected.to respond_with :unauthorized }
    end

    def mock!
      request.headers['X-Amz-Sns-Topic-Arn'] = account.aws_topic_arn

      expect(Account).to receive(:find_by)
        .with(api_key: account.api_key)
        .and_return(account)

      expect_any_instance_of(Fog::AWS::SNS::MessageVerifier)
        .to receive(:authenticate!)
    end

    def fixture(path)
      JSON.parse File.read("spec/vcr/#{path}.json")
    end
  end
end
