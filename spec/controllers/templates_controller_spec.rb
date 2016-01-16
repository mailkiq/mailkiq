require 'rails_helper'

describe TemplatesController, type: :controller do
  context 'when logged in' do
    let(:template) { Fabricate.build(:template) }
    let(:template_params) { Fabricate.attributes_for(:template) }

    before do
      @account = Fabricate.build(:account)
      sign_in_as @account
    end

    describe 'GET /templates' do
      before { get :index }

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
      it { expect(assigns(:templates)).to_not be_nil }
    end

    describe 'GET /templates/new' do
      before { get :new }

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
      it { expect(assigns(:template)).to be_a_new Template }
    end

    describe 'POST /templates' do
      before do
        allow_any_instance_of(Template).to receive(:save).and_return(true)
        post :create, template: template_params
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to templates_path }
      it { is_expected.to set_flash[:notice] }
      it { is_expected.to permit_for(:create) }
    end

    describe 'GET /templates/:id/edit' do
      before do
        allow(@account.templates).to receive(:find).and_return(template)
        get :edit, id: template.id
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
      it { expect(assigns(:template)).to eq(template) }
    end

    describe 'PATCH /templates/:id' do
      before do
        stub_model_action :update
        patch :update, template: template_params, id: template.id
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to templates_path }
      it { is_expected.to set_flash[:notice] }
      it { is_expected.to permit_for(:update) }
    end

    describe 'DELETE /templates/:id' do
      before do
        stub_model_action :destroy
        delete :destroy, id: template.id
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to templates_path }
      it { is_expected.to set_flash[:notice] }
    end

    def permit_for(action_name)
      params = { template: template_params, id: template.id }
      permit(:name, :html_text).for(action_name, params: params).on(:template)
    end

    def stub_model_action(method_name)
      allow(template).to receive(method_name).and_return(true)
      allow(@account.templates).to receive(:find).and_return(template)
    end
  end
end
