require 'rails_helper'

describe API::V1::ContactsController, type: :controller do
  context 'when logged in' do
    describe '#create' do
      let(:account) { Fabricate.build :valid_account, id: 10 }
      let(:params) do
        data = fixture(:clickfunnels, json: true)
        data[:api_key] = account.api_key
        data
      end

      let(:digest) do
        url = api_v1_contacts_url(params)
        Digest::MD5.hexdigest("#{url}#{params.except(:api_key).to_query}")
      end

      before do
        request.headers['X-Clickfunnels-Webhook-Delivery-Id'] = digest

        allow(ActiveRecord::Base).to receive(:transaction).and_yield
        expect_sign_in_as account
        expect_any_instance_of(Subscriber).to receive(:valid?).and_return(true)
        expect_any_instance_of(Subscriber).to receive(:save) { |model| model }
        expect_any_instance_of(API::V1::SubscriberResource)
          .to receive(:redefine_model)

        post :create, params
      end

      it { is_expected.to use_before_action :authenticate! }
      it { is_expected.to use_before_action :validate_webhook }
      it { is_expected.to respond_with :created }
      it { expect(response.content_type).to eq Mime::JSON }

      it 'keeps id attribute unchanged' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['id']).to be_nil
      end
    end
  end
end
