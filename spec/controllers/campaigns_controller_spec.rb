require 'rails_helper'

describe CampaignsController, type: :controller do
  context 'when logged in' do
    let(:account) { Fabricate.build :account }
    let(:campaign) { Fabricate.build :campaign, id: 1 }

    before { sign_in_as account }

    describe 'GET /campaigns' do
      before do
        relation = double
        expect(relation).to receive(:recents)
        expect(controller).to receive(:apply_scopes)
          .with(account.campaigns)
          .and_return(relation)

        get :index
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :index }

      it { is_expected.to have_scope :sort }
      it { is_expected.to have_scope :page }
    end

    describe 'GET /campaigns/new' do
      before do
        expect(account).to receive_message_chain(:campaigns, :new)
        get :new
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :new }
    end

    describe 'POST /campaigns' do
      let(:params) { Fabricate.attributes_for(:campaign) }

      before do
        allow(account).to receive_message_chain(:campaigns, :create)
          .with(params)

        post :create, campaign: params
      end

      it { is_expected.to use_before_action :require_login }
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

    describe 'GET /campaigns/:id/edit' do
      before do
        expect(account).to receive_message_chain(:campaigns, :find)
          .with(campaign.id.to_s)
          .and_return(campaign)

        get :edit, id: campaign.id
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to use_before_action :find_campaign }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :edit }
    end

    describe 'PATCH /campaigns/:id' do
      let(:params) { Fabricate.attributes_for(:freeletics_campaign) }

      before do
        mock!
        allow(campaign).to receive(:update).with params
        patch :update, id: campaign.id, campaign: params
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to use_before_action :find_campaign }
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

    describe 'DELETE /campaigns/:id' do
      before do
        mock!
        expect(campaign.queue).to receive(:clear)
        expect(campaign).to receive(:destroy)
        delete :destroy, id: campaign.id
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to use_before_action :find_campaign }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to campaigns_path }
      it { is_expected.to set_flash[:notice] }
    end

    describe 'GET /campaigns/:id/preview' do
      before do
        mock!
        get :preview, id: campaign.id
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to use_before_action :find_campaign }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :preview }
      it { is_expected.to_not render_with_layout }
    end
  end

  def mock!
    allow(account).to receive_message_chain(:campaigns, :find)
      .with(campaign.id.to_s)
      .and_return(campaign)
  end
end
