require 'rails_helper'

RSpec.describe API::V1::ConversionsController, type: :request do
  context 'when logged in' do
    let(:account) { Fabricate :account }

    describe 'POST /api/v1/conversions' do
      it 'creates a new subscriber and redirect to the specified URI' do
        data = { email: account.email, redirect_to: 'http://bit.ly' }

        post api_v1_conversions_path(api_key: account.api_key), params: data

        expect(account.subscribers.count).to eq(1)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(data[:redirect_to])
      end
    end
  end
end
