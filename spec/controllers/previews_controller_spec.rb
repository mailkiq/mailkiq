require 'rails_helper'

describe PreviewsController, type: :controller do
  context 'when logged in' do
    let(:account) { Fabricate.build :account }
    let(:campaign) { Fabricate.build :campaign, account: account, id: 1 }

    before { sign_in account }

    describe '#show' do
      before do
        expect(account).to receive_message_chain(:campaigns, :find)
          .with(campaign.id.to_s)

        get :show, campaign_id: campaign.id
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :show }
      it { is_expected.to_not render_with_layout }
    end

    describe '#create' do
      before do
        post :create, campaign_id: campaign.id
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
    end
  end
end
