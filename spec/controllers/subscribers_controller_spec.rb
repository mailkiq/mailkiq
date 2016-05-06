require 'rails_helper'

describe SubscribersController, type: :controller do
  context 'when logged in' do
    let(:account) { Fabricate.build :account }

    before { sign_in account }

    describe '#index' do
      before do
        scope = double('scope')
        expect(scope).to receive(:recent).with(no_args)
        expect(scope).to receive(:page).with(1).and_return(scope)
        expect(account).to receive(:subscribers).and_return(scope)
        expect(controller).to receive(:apply_scopes).with(scope)
          .and_call_original

        get :index
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :index }
      it { is_expected.to have_scope :page }
      it { is_expected.to have_scope :sort }
    end

    describe '#new' do
      before do
        expect(account).to receive_message_chain(:subscribers, :new)
        get :new
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :new }
    end

    describe '#create' do
      let(:params) { Fabricate.attributes_for(:subscriber) }

      before do
        allow(account).to receive_message_chain(:subscribers, :create)
          .with(params)

        post :create, subscriber: params
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to subscribers_path }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(:name, :email, :state, tag_ids: [])
          .for(:create, params: { subscriber: params })
          .on(:subscriber)
      end
    end

    describe '#edit' do
      let(:subscriber) { Fabricate.build :subscriber, id: 1 }

      before do
        mock!
        get :edit, id: subscriber.id
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :edit }
    end

    describe '#update' do
      let(:subscriber) { Fabricate.build :subscriber, id: 1 }
      let(:params) { Fabricate.attributes_for(:maria_doe) }

      before do
        mock!
        allow(subscriber).to receive(:update).with params
        patch :update, id: subscriber.id, subscriber: params
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to subscribers_path }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(:name, :email, :state)
          .for(:update, params: { id: subscriber.id, subscriber: params })
          .on(:subscriber)
      end
    end

    describe '#destroy' do
      let(:subscriber) { Fabricate.build :subscriber, id: 1 }

      before do
        mock!
        expect(subscriber).to receive(:destroy)
        delete :destroy, id: subscriber.id
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to subscribers_path }
      it { is_expected.to set_flash[:notice] }
    end
  end

  def mock!
    allow(account).to receive_message_chain(:subscribers, :find)
      .with(subscriber.id.to_s)
      .and_return(subscriber)
  end
end
