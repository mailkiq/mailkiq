require 'rails_helper'

describe DashboardController, type: :controller do
  context 'when logged in' do
    describe 'GET /' do
      before do
        account = Fabricate.build(:account)
        sign_in_as account
        get :show
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
    end
  end
end
