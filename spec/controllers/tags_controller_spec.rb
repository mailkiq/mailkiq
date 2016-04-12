require 'rails_helper'

describe TagsController, type: :controller do
  context 'when logged in' do
    let(:account) { Fabricate.build :valid_account }
    let(:tag) { Tag.new }

    before do
      sign_in account
    end

    describe '#index' do
      before { get :index }

      it { is_expected.to respond_with :success }
      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to render_template :index }
      it { is_expected.to have_scope(:page) }
    end

    describe '#new' do
      let(:tag) { assigns(:tag) }

      before { get :new }

      it { is_expected.to respond_with :success }
      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to render_template :new }
      it { expect(tag).to be_new_record }
    end

    describe '#create' do
      let(:params) do
        { tag: { name: 'teste' } }
      end

      before do
        allow_any_instance_of(Tag).to receive(:save)
        post :create, params
      end

      it { is_expected.to respond_with :redirect }
      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to redirect_to tags_path }
      it { is_expected.to permit(:name).for(:create, params: params).on(:tag) }
      it { is_expected.to set_flash[:notice] }
    end

    describe '#edit' do
      before do
        mock!
        get :edit, id: '1'
      end

      it { is_expected.to respond_with :success }
      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to render_template :edit }
    end

    describe '#update' do
      let(:params) do
        { tag: { name: 'another name' }, id: '1' }
      end

      before do
        mock! :update
        patch :update, params
      end

      it { is_expected.to respond_with :redirect }
      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to redirect_to tags_path }
      it { is_expected.to permit(:name).for(:update, params: params).on(:tag) }
      it { is_expected.to set_flash[:notice] }
    end

    describe '#destroy' do
      before do
        mock! :destroy
        delete :destroy, id: '1'
      end

      it { is_expected.to respond_with :redirect }
      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to redirect_to tags_path }
      it { is_expected.to set_flash[:notice] }
    end
  end

  def mock!(method = nil)
    allow(tag).to receive(method) if method
    allow(account).to receive_message_chain(:tags, :find).with('1')
      .and_return(tag)
  end
end
