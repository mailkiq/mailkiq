require 'rails_helper'

describe CampaignsController, type: :controller do
  context 'when logged in' do
    before do
      sign_in_as Fabricate.build(:account)
      get :index
    end

    describe 'GET /campaigns' do
      before { get :index }

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout 'admin' }
    end
  end
end
