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

    describe '#create' do
      before do
        expect_any_instance_of(SubscriberImporter).to receive(:process!)
        post :create, import: { csv: 'teste@teste.com,Teste' }
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to new_import_path }
    end
  end
end
