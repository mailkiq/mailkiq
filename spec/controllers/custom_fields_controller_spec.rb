require 'rails_helper'

describe CustomFieldsController, type: :controller do
  context 'when logged in' do
    before do
      @account = Fabricate.build(:account)
      sign_in_as @account
    end

    describe 'GET /custom_fields' do
      before do
        list = Fabricate.build(:list)
        allow(@account.lists).to receive(:find).and_return(list)
        get :index, list_id: 10
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
    end
  end
end
