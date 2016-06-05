require 'rails_helper'

describe API::V1::ContactsController, type: :request do
  context 'when logged in' do
    describe 'POST /api/v1/contacts' do
      let(:account) { Fabricate :account }
      let(:params) { json :clickfunnels }

      it 'creates a new subscriber' do
        expect(ConfirmationJob).to receive(:enqueue)

        post api_v1_contacts_path(api_key: account.api_key), params.to_json,
             'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s

        expect(response).to have_http_status :created
        expect(response.content_type).to eq Mime::JSON

        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response[:name]).to be_nil
        expect(json_response[:state]).to eq('unconfirmed')
        expect(json_response[:account_id]).to eq(account.id)
        expect(json_response[:email])
          .to eq(params.dig(:data, :attributes, :email))
      end
    end
  end
end
