require 'rails_helper'

describe SettingsController, type: :controller do
  context 'when logged in' do
    let(:account) { Fabricate.build :account }

    describe '#edit' do
      before do
        expect(DomainJob).to receive(:enqueue).with(account.id)
        sign_in account
        get :edit
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :edit }
    end

    describe '#update' do
      let(:params) do
        { account: Fabricate.attributes_for(:jane_doe) }
      end

      before do
        expect(account).to receive(:update).and_return(true).at_least(:once)
        sign_in account
        put :update, params
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to set_flash[:notice] }
      it do
        is_expected
          .to permit(:aws_access_key_id, :aws_secret_access_key, :aws_region)
          .for(:update, params: params)
          .on(:account)
      end
    end
  end
end
