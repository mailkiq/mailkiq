require 'rails_helper'

describe CampaignsController, type: :controller do
  context 'when logged in' do
    let(:account) { Fabricate.build :account }
    let(:campaign) { Fabricate.build :campaign, account: account, id: 1 }

    before { sign_in account }

    describe '#index' do
      before do
        scope = double('scope')
        expect(scope).to receive(:recent).with(no_args)
        expect(scope).to receive(:page).with(1).and_return(scope)
        expect(account).to receive(:campaigns).and_return(scope)
        expect(controller).to receive(:apply_scopes).with(scope)
          .and_call_original

        get :index
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :index }
      it { is_expected.to have_scope :sort }
      it { is_expected.to have_scope :page }
    end

    describe '#show' do
      before do
        mock!
        get :show, id: campaign.id
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :show }

      it 'sets page title to the campaign name' do
        expect(controller.page_meta[:name]).to eq(campaign.name)
      end
    end

    describe '#new' do
      before do
        expect(account).to receive_message_chain(:campaigns, :new)
        get :new
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :new }
    end

    describe '#create' do
      let(:params) { Fabricate.attributes_for(:campaign) }

      before do
        allow(account).to receive_message_chain(:campaigns, :create)
          .with(params)

        post :create, campaign: params
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to campaigns_path }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(:name, :subject, :from_name, :from_email,
                              :html_text, :plain_text)
          .for(:create, params: { campaign: params })
          .on(:campaign)
      end
    end

    describe '#edit' do
      before do
        mock!
        get :edit, id: campaign.id
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :edit }
    end

    describe '#update' do
      let(:params) { Fabricate.attributes_for(:freeletics_campaign) }

      before do
        mock!
        allow(campaign).to receive(:update).with params
        patch :update, id: campaign.id, campaign: params
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to campaigns_path }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(:name, :subject, :from_name, :from_email,
                              :html_text, :plain_text)
          .for(:update, params: { id: campaign.id, campaign: params })
          .on(:campaign)
      end
    end

    describe '#destroy' do
      before do
        mock!
        expect(campaign).to receive(:destroy)
        expect_any_instance_of(Delivery).to receive(:delete)
        delete :destroy, id: campaign.id
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to campaigns_path }
      it { is_expected.to set_flash[:notice] }
    end

    describe '#duplicate' do
      before do
        mock!
        expect(campaign).to receive(:duplicate).and_call_original
        expect_any_instance_of(Campaign).to receive(:save)
        post :duplicate, id: campaign.id
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to campaigns_path }
      it { is_expected.to set_flash[:notice] }
    end
  end

  def mock!
    relation = double('relation')

    allow(relation).to receive(:find).with(campaign.id.to_s)
      .and_return(campaign)

    allow(relation).to receive_message_chain(:draft, :find)
      .with(campaign.id.to_s)
      .and_return(campaign)

    allow(account).to receive_message_chain(:campaigns).and_return(relation)
  end
end
