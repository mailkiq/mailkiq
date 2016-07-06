require 'rails_helper'

RSpec.describe API::V1::ContactsController, type: :request do
  context 'when logged in' do
    let(:account) { Fabricate :account }
    let(:params) { json :clickfunnels }

    describe 'POST /api/v1/contacts' do
      context 'with valid params' do
        it 'inserts a new subscriber on the database' do
          post api_v1_contacts_path(api_key: account.api_key),
               params: params.to_json,
               headers: { 'Content-Type' => Mime[:json].to_s,
                          'Accept'       => Mime[:json] }

          json_response = JSON.parse(response.body, symbolize_names: true)

          expect(response).to have_http_status :created
          expect(response.content_type).to eq Mime[:json]
          expect(json_response[:name]).to be_nil
          expect(json_response[:state]).to eq('unconfirmed')
          expect(json_response[:account_id]).to eq(account.id)
          expect(json_response[:email])
            .to eq(params.dig(:data, :attributes, :email))

          expect(account.subscribers.count).to eq(1)
        end
      end

      context 'email already exists' do
        it 'raises ActiveRecord::RecordNotUnique exception' do
          expect(Appsignal).to receive(:add_exception)

          expect_any_instance_of(Subscriber).to receive(:save!)
            .and_raise(ActiveRecord::RecordNotUnique, 'duplicate key value')

          post api_v1_contacts_path(api_key: account.api_key),
               params: params.to_json,
               headers: { 'Content-Type' => Mime[:json].to_s,
                          'Accept'       => Mime[:json] }

          json_response = JSON.parse(response.body, symbolize_names: true)

          expect(response).to have_http_status :unprocessable_entity
          expect(response.content_type).to eq Mime[:json]
          expect(json_response[:message]).to eq('Email address already exists')
        end
      end
    end
  end
end
