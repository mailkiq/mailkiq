require 'rails_helper'

describe AutomationsController, type: :controller do
  context 'when logged in' do
    let(:account) { Fabricate.build :account }
    let(:automation) { Fabricate.build :automation }
    let(:params) { Fabricate.attributes_for :automation }

    before { sign_in account }

    describe '#index' do
      before { get :index }

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :index }
    end

    describe '#new' do
      before { get :new }

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :new }
    end

    describe '#create' do
      before do
        allow(account).to receive_message_chain(:automations, :create)
          .with(params)

        post :create, automation: params
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to automations_path }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(:name, :campaign_id)
          .for(:create, params: { automation: params })
          .on(:automation)
      end
    end

    describe '#edit' do
      before do
        mock!
        get :edit, id: 1
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :edit }
    end

    describe '#update' do
      before do
        mock!
        expect(automation).to receive(:update).at_least(:once).with(params)
        put :update, id: 1, automation: params
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to automations_path }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(:name, :campaign_id)
          .for(:update, params: { id: 1, automation: params })
          .on(:automation)
      end
    end

    describe '#destroy' do
      before do
        mock!
        expect(automation).to receive(:destroy)
        delete :destroy, id: 1
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to automations_path }
      it { is_expected.to set_flash[:notice] }
    end
  end

  def mock!
    allow(account).to receive_message_chain(:automations, :find)
      .and_return(automation)
  end
end
