require 'rails_helper'

describe AutomationsController, type: :controller do
  context 'when logged in' do
    let(:account) { Fabricate.build :account }
    let(:automation) { Fabricate.build :automation, id: 1 }
    let(:params) do
      { name: 'zzz', campaign_attributes: Fabricate.attributes_for(:campaign) }
    end

    before { sign_in account }

    describe '#index' do
      before do
        scope = double('scope')
        expect(scope).to receive(:recent).with(no_args)
        expect(scope).to receive(:page).with(1).and_return(scope)
        expect(account).to receive(:automations).and_return(scope)
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

    describe '#new' do
      before { get :new }

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :new }
    end

    describe '#create' do
      before do
        allow_any_instance_of(Automation).to receive(:save)
        post :create, automation: params
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to automations_path }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(:name, :subject, :from_name, :from_email,
                              :html_text, :plain_text, :send_type)
          .for(:create, params: { automation: params })
          .on(:automation)
      end
    end

    describe '#edit' do
      before do
        mock!
        get :edit, id: automation.id
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :edit }
    end

    describe '#update' do
      before do
        mock!
        expect(automation).to receive(:update).at_least(:once)
        put :update, id: automation.id, automation: params
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to automations_path }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(:name, :subject, :from_name, :from_email,
                              :html_text, :plain_text, :send_type)
          .for(:update, params: { id: 1, automation: params })
          .on(:automation)
      end
    end

    describe '#destroy' do
      before do
        mock!
        expect(automation).to receive(:destroy)
        delete :destroy, id: automation.id
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to automations_path }
      it { is_expected.to set_flash[:notice] }
    end

    describe '#pause' do
      before do
        mock!
        expect(automation).to receive(:paused!)
        patch :pause, id: automation.id
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to automations_path }
      it { is_expected.to set_flash[:notice] }
    end

    describe '#resume' do
      before do
        mock!
        expect(automation).to receive(:sending!)
        patch :resume, id: automation.id
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
