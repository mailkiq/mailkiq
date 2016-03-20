require 'rails_helper'

describe API::V1::NotificationsController, type: :controller do
  describe 'POST /api/v1/notifications', :api do
    let(:account) { Fabricate.build :valid_account }

    context 'confirmation', vcr: { cassette_name: :confirm_subscription } do
      let(:subscription_confirmation) { fixture :subscription_confirmation }
      let(:sns) { assigns :sns }

      before do
        expect_any_instance_of(Fog::AWS::SNS::MessageVerifier)
          .to receive(:authenticate!)

        api_sign_in(account)
        request.headers['X-Amz-Sns-Topic-Arn'] = account.aws_topic_arn
        request.env['RAW_POST_DATA'] = subscription_confirmation.to_json

        post :create, format: :json, api_key: account.api_key
      end

      it { is_expected.to filter_param :api_key }
      it { is_expected.to respond_with :success }
      it { is_expected.to use_before_action :authenticate! }
      it { expect(sns).to be_subscription_confirmation }
    end

    context 'inserts new notification' do
      let(:bounce) { fixture :bounce }
      let(:sns) { Fog::AWS::SNS::Notification.new bounce }
      let(:message) { Message.new id: 1 }

      before do
        expect_any_instance_of(Fog::AWS::SNS::MessageVerifier)
          .to receive(:authenticate!)

        api_sign_in(account)
        request.headers['X-Amz-Sns-Topic-Arn'] = account.aws_topic_arn
        request.env['RAW_POST_DATA'] = bounce.to_json

        expect(account)
          .to receive_message_chain(:subscribers, :where, :update_all)
          .with(state: Subscriber.states[:bounced])

        expect(Message).to receive(:find_by!).and_return(message)
        expect(message).to receive_message_chain(:notifications, :create!)
          .with(type: sns.message.type.downcase,
                data: sns.data.as_json)

        post :create, format: :json, api_key: account.api_key
      end

      it { is_expected.to filter_param :api_key }
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

    context 'amazon headers' do
      before do
        expect(Account).to receive(:find_by).and_return(nil)
        post :create, format: :json
      end

      it { is_expected.to respond_with :unauthorized }
    end
  end
end
