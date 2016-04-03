require 'rails_helper'

describe SettingsController, type: :controller do
  context 'when logged in' do
    let(:params) do
      { account: Fabricate.attributes_for(:jane_doe) }
    end

    before do
      account = Fabricate.build(:account)
      expect(account).to receive(:update).at_most(:twice)
      sign_in account
    end

    describe 'PUT /settings/domains' do
      before do
        expect(DomainWorker).to receive(:perform_async).at_least(:once)
        put :domains, params
      end

      it { is_expected.to use_before_action :authenticate_account! }
      it { is_expected.to respond_with :success }
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
