require 'rails_helper'

describe CampaignsController, type: :controller do
  context 'when logged in' do
    before do
      @account = Fabricate.build(:account)
      sign_in_as @account
    end

    describe 'GET /campaigns' do
      before do
        allow(@account).to receive(:campaigns)
        get :index
      end
      it { is_expected.to use_before_action :require_login }
      it { is_expected.to render_with_layout 'admin' }
      it { is_expected.to respond_with :success }
    end

    describe 'GET /campaigns/new' do
      before do
        allow(@account).to receive_message_chain(:campaigns, :new)
        get :new
      end
      it { is_expected.to use_before_action :require_login }
      it { is_expected.to render_with_layout 'admin' }
      it { is_expected.to respond_with :success }
    end

    describe 'POST /campaigns' do
      before do
        @params = Fabricate.attributes_for(:campaign)

        allow(@account).to receive_message_chain(:campaigns, :create)
          .with(@params)

        post :create, campaign: @params
      end
      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to campaigns_path }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(:name, :subject, :from_name, :from_email, :reply_to, :html_text)
          .for(:create, params: { campaign: @params })
          .on(:campaign)
      end
    end

    describe 'GET /campaigns/:id/edit' do
      before do
        @campaign = Fabricate.build :campaign, id: 1

        allow(@account).to receive_message_chain(:campaigns, :find)
          .with(@campaign.id.to_s)
          .and_return(@campaign)

        get :edit, id: @campaign.id
      end
      it { is_expected.to use_before_action :require_login }
      it { is_expected.to render_with_layout 'admin' }
      it { is_expected.to respond_with :success }
    end

    describe 'PATCH /campaigns/:id' do
      before do
        @campaign = Fabricate.build :campaign, id: 1
        @params = Fabricate.attributes_for(:freeletics_campaign)

        stub_find
        allow(@campaign).to receive(:update).with @params

        patch :update, id: @campaign.id, campaign: @params
      end
      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to campaigns_path }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(:name, :subject, :from_name, :from_email, :reply_to, :html_text)
          .for(:update, params: { id: @campaign.id, campaign: @params })
          .on(:campaign)
      end
    end

    describe 'DELETE /campaigns/:id' do
      before do
        @campaign = Fabricate.build :campaign, id: 1

        stub_find
        allow(@campaign).to receive(:destroy)

        delete :destroy, id: @campaign.id
      end
      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to campaigns_path }
      it { is_expected.to set_flash[:notice] }
    end

    def stub_find
      allow(@account).to receive_message_chain(:campaigns, :find)
        .with(@campaign.id.to_s)
        .and_return(@campaign)
    end
  end
end
