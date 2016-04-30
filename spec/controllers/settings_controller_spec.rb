require 'rails_helper'

describe SettingsController, type: :controller do
  context 'when logged in' do
    describe '#domains' do
      let(:account) { Fabricate.build :account }
      let(:params) do
        { account: Fabricate.attributes_for(:jane_doe) }
      end

      before do
        expect(account).to receive(:update).at_least(:once)
        expect(DomainWorker).to receive(:perform_async).at_least(:once)
        sign_in account
        put :domains, params
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
      it { is_expected.to render_template :domains }
      it { is_expected.to set_flash.now[:notice] }
      it do
        is_expected
          .to permit(:aws_access_key_id, :aws_secret_access_key, :aws_region)
          .for(:domains, verb: :put, params: params)
          .on(:account)
      end
    end
  end
end
