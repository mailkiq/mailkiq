require 'rails_helper'

describe CustomFieldsController, type: :controller do
  context 'when logged in' do
    before do
      @list = Fabricate.build(:list)
      @account = Fabricate.build(:account)
      allow(@account.lists).to receive(:find).and_return(@list)
      sign_in_as @account
    end

    describe 'GET /custom_fields' do
      before { get :index, list_id: @list.id }

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
      it { expect(assigns(:custom_fields)).to_not be_nil }
    end

    describe 'GET /custom_fields/new' do
      before { get :new, list_id: @list.id }

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
      it { expect(assigns(:custom_field)).to be_a_new CustomField }
    end

    describe 'POST /custom_fields' do
      before do
        allow_any_instance_of(CustomField).to receive(:save).and_return true
        post :create, list_id: @list.id, custom_field: { field_name: 'Age' }
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to list_custom_fields_path(@list) }
      it { is_expected.to set_flash[:notice] }
    end
  end
end
