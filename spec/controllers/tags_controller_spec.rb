require 'rails_helper'

describe TagsController, type: :controller do
  let(:account) { Fabricate.build :valid_account }

  before do
    sign_in_as account
  end

  describe 'GET /tags' do
    before { get :index }

    it { is_expected.to respond_with :success }
  end
end
