require 'rails_helper'

describe CustomFieldsController, type: :controller do
  context 'when logged in' do
    before do
      @list = Fabricate.build(:list)
      @account = Fabricate.build(:account)
      allow(@account.lists).to receive(:find).and_return(@list)
      sign_in_as @account
    end

    let(:params) do
      { custom_field: { field_name: 'Age' }, list_id: @list.id }
    end

    describe 'GET /lists/:list_id/custom_fields' do
      before { get :index, list_id: @list.id }

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
    end

    describe 'POST /lists/:list_id/custom_fields' do
      before do
        allow_any_instance_of(CustomField).to receive(:save).and_return true
        post :create, params
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to list_custom_fields_path(@list) }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected.to permit(:field_name, :data_type, :hidden)
          .for(:create, params: params).on(:custom_field)
      end
    end

    describe 'GET /lists/:list_id/custom_fields/:id' do
      before do
        custom_field = Fabricate.build(:custom_field)
        allow(@list.custom_fields).to receive(:find).and_return(custom_field)
        get :edit, list_id: @list.id, id: custom_field.id
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
    end

    describe 'PATCH /lists/:list_id/custom_fields/:id' do
      before do
        custom_field = Fabricate.build(:custom_field)
        allow(custom_field).to receive(:update).and_return(true)
        allow(@list.custom_fields).to receive(:find).and_return(custom_field)
        patch :update, params.merge(id: custom_field.id)
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to list_custom_fields_path(@list) }
      it { is_expected.to set_flash[:notice] }
    end

    describe 'DELETE /lists/:list_id/custom_fields/:id' do
      before do
        custom_field = CustomField.new
        allow(@list.custom_fields).to receive(:find).and_return(custom_field)
        allow_any_instance_of(CustomField).to receive(:destroy).and_return true
        delete :destroy, list_id: @list.id, id: 99
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to list_custom_fields_path(@list) }
      it { is_expected.to set_flash[:notice] }
    end
  end
end
