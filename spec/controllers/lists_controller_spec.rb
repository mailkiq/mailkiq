require 'rails_helper'

describe ListsController, type: :controller do
  context 'when logged in' do
    let(:list) { Fabricate.build(:list) }
    let(:list_params) { Fabricate.attributes_for(:list) }

    before do
      @account = Fabricate.build(:account)
      sign_in_as @account
    end

    describe 'GET /lists' do
      before { get :index }

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
      it { expect(assigns(:lists)).to_not be_nil }
    end

    describe 'GET /lists/:id' do
      before do
        allow(@account.lists).to receive(:find).and_return(list)
        get :show, id: list.id
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
      it { expect(assigns(:list)).to eq(list) }
    end

    describe 'GET /lists/new' do
      before { get :new }

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
      it { expect(assigns(:list)).to be_a_new List }
    end

    describe 'POST /lists' do
      before do
        allow_any_instance_of(List).to receive(:save).and_return(true)
        post :create, list: list_params
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to lists_path }
      it { is_expected.to set_flash[:notice] }
      it { is_expected.to permit_for(:create) }
    end

    describe 'GET /lists/:id/edit' do
      before do
        allow(@account.lists).to receive(:find).and_return(list)
        get :edit, id: list.id
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
      it { expect(assigns(:list)).to eq(list) }
    end

    describe 'PATCH /lists/:id' do
      before do
        stub_model_action :update
        patch :update, list: list_params, id: list.id
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to lists_path }
      it { is_expected.to set_flash[:notice] }
      it { is_expected.to permit_for(:update) }
    end

    describe 'DELETE /lists/:id' do
      before do
        stub_model_action :destroy
        delete :destroy, id: list.id
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to lists_path }
      it { is_expected.to set_flash[:notice] }
    end

    def permit_for(action_name)
      permit(:name, :double_optin, :confirm_url, :subscribed_url,
             :unsubscribed_url, :thankyou, :thankyou_subject, :thankyou_message,
             :goodbye, :goodbye_subject, :goodbye_message,
             :confirmation_subject, :confirmation_message,
             :unsubscribe_all_list)
        .for(action_name, params: { list: list_params, id: list.id }).on(:list)
    end

    def stub_model_action(method_name)
      allow(list).to receive(method_name).and_return(true)
      allow(@account.lists).to receive(:find).and_return(list)
    end
  end
end
