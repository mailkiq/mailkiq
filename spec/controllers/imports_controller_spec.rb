require 'rails_helper'

describe ImportsController, type: :controller do
  context 'when logged in' do
    let(:account) { Fabricate.build :account }

    before { sign_in account }

    describe '#new' do
      before { get :new }

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to render_template :new }
      it { is_expected.to respond_with :success }
    end
  end
end
