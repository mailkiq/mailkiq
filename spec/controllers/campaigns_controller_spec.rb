require 'rails_helper'

describe CampaignsController, type: :controller do
  context 'when logged in' do
    before do
      @account = Fabricate.build(:account)
      sign_in_as @account
    end

    it_behaves_like 'a index request', path: '/campaigns'

    it_behaves_like 'a new request', path: '/campaigns/new'

    it_behaves_like 'a create request', path: '/campaigns' do
      before do
        allow(@account).to receive_message_chain(:campaigns, :create)
          .with(params)
      end

      let(:params) { Fabricate.attributes_for :campaign }
      let(:permitted_params) do
        %i(name subject from_name from_email reply_to html_text)
      end
    end
  end
end
