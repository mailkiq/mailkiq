require 'rails_helper'

describe API::V1::ConversionsController, type: :request do
  context 'when logged in' do
    describe 'POST /api/v1/conversions' do
      let(:account) { Fabricate :account }

      it 'creates a new subscriber and redirect to the specified URI' do
        data = { email: account.email, redirect_to: 'http://bit.ly' }

        expect do
          post api_v1_conversions_path(api_key: account.api_key), data,
               'HTTPS' => 'on'
        end.to change { account.subscribers.count }.by(1)

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(data[:redirect_to])
      end
    end
  end
end
