require 'rails_helper'

describe SubscribersController, type: :controller do
  context 'when logged in' do
    let(:account) { Fabricate.build :account }

    before { sign_in_as account }

    describe 'GET /subscribers' do
      before do
        expect(account).to receive_message_chain(:subscribers, :page)
        get :index
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to render_with_layout 'admin' }
      it { is_expected.to respond_with :success }
    end

    describe 'GET /subscribers/new' do
      before do
        expect(account).to receive_message_chain(:subscribers, :new)
        get :new
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to render_with_layout 'admin' }
      it { is_expected.to respond_with :success }
    end

    describe 'POST /subscribers' do
      let(:params) { Fabricate.attributes_for(:subscriber) }

      before do
        allow(account).to receive_message_chain(:subscribers, :create)
          .with(params)

        post :create, subscriber: params
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to subscribers_path }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(:name, :email, :state, tag_ids: [])
          .for(:create, params: { subscriber: params })
          .on(:subscriber)
      end
    end

    describe 'GET /subscribers/:id/edit' do
      let(:subscriber) { Fabricate.build :subscriber, id: 1 }

      before do
        expect(account).to receive_message_chain(:subscribers, :find)
          .with(subscriber.id.to_s)
          .and_return(subscriber)

        get :edit, id: subscriber.id
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to render_with_layout 'admin' }
      it { is_expected.to respond_with :success }
    end

    describe 'PATCH /subscribers/:id' do
      let(:subscriber) { Fabricate.build :subscriber, id: 1 }
      let(:params) { Fabricate.attributes_for(:maria_doe) }

      before do
        mock!
        allow(subscriber).to receive(:update).with params
        patch :update, id: subscriber.id, subscriber: params
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to subscribers_path }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(:name, :email, :state, tag_ids: [])
          .for(:update, params: { id: subscriber.id, subscriber: params })
          .on(:subscriber)
      end
    end

    describe 'DELETE /subscribers/:id' do
      let(:subscriber) { Fabricate.build :subscriber, id: 1 }

      before do
        mock!
        expect(subscriber).to receive(:destroy)
        delete :destroy, id: subscriber.id
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to subscribers_path }
      it { is_expected.to set_flash[:notice] }
    end

    def mock!
      allow(account).to receive_message_chain(:subscribers, :find)
        .with(subscriber.id.to_s)
        .and_return(subscriber)
    end
  end
end
