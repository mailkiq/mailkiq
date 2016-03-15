require 'rails_helper'

describe SettingsController, type: :controller do
  context 'when logged in' do
    let(:amazon_params) { %i(aws_access_key_id aws_secret_access_key aws_region) }
    let(:profile_params) { %i(name email password language time_zone) }
    let(:account_params) do
      { account: Fabricate.attributes_for(:jane_doe) }
    end

    before do
      account = Fabricate.build(:account)
      expect(account).to receive(:update).at_most(:twice)
      sign_in_as account
    end

    describe 'PUT /settings/profile' do
      before { put :profile, account_params }

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to set_flash.now[:notice] }
      it { is_expected.to permit_params(profile_params) }
      it { is_expected.not_to permit_params(amazon_params) }
    end

    describe 'PUT /settings/amazon' do
      before do
        expect(DomainWorker).to receive(:perform_async).at_least(:once)
        put :amazon, account_params
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to set_flash.now[:notice] }
      it { is_expected.to permit_params(amazon_params) }
      it { is_expected.not_to permit_params(profile_params) }
    end

    def permit_params(params)
      permit(*params).on(:account)
        .for(controller.action_name, verb: :put, params: account_params)
    end
  end
end
