require 'rails_helper'

describe DashboardController, type: :controller do
  context 'when logged in' do
    describe 'GET /' do
      before do
        account = Fabricate.build(:account)
        sign_in account
        get :show
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
    end
  end
end
