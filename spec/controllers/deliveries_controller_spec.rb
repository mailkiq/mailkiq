require 'rails_helper'

describe DeliveriesController, type: :controller do
  context 'when logged in' do
    let(:account) { Fabricate.build :account }
    let(:campaign) { Fabricate.build :campaign, account: account, id: 10 }

    before do
      allow_any_instance_of(Delivery).to receive(:chain_queries).and_return([])
      allow(account).to receive_message_chain(:campaigns, :unsent, :find)
        .and_return(campaign)

      sign_in account
    end

    describe '#new' do
      before { get :new, campaign_id: campaign.id }

      it { is_expected.to respond_with :success }
      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to use_before_action :set_campaign }
      it { is_expected.to render_template :new }
    end

    describe '#create' do
      let(:params) do
        {
          campaign_id: campaign.id,
          campaign: {
            tagged_with: ['das'],
            not_tagged_with: ['dsa']
          }
        }
      end

      before { post :create, params }

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to use_before_action :set_campaign }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to campaign_path(campaign) }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(tagged_with: [], not_tagged_with: [])
          .for(:create, params: params)
          .on(:campaign)
      end
    end
  end
end
