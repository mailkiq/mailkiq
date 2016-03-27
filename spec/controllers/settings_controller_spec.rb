require 'rails_helper'

describe SettingsController, type: :controller do
  context 'when logged in' do
    let(:domains_params) do
      %i(aws_access_key_id aws_secret_access_key aws_region)
    end

    let(:account_params) do
      %i(name email time_zone current_password password password_confirmation)
    end

    let(:params) do
      { account: Fabricate.attributes_for(:jane_doe) }
    end

    before do
      account = Fabricate.build(:account)
      expect(account).to receive(:update).at_most(:twice)
      sign_in_as account
    end

    describe 'PUT /settings/account' do
      before { put :account, params }

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to set_flash.now[:notice] }
      it { is_expected.to permit_params(account_params) }
      it { is_expected.not_to permit_params(domains_params) }
    end

    describe 'PUT /settings/domains' do
      before do
        expect(DomainWorker).to receive(:perform_async).at_least(:once)
        put :domains, params
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to set_flash.now[:notice] }
      it { is_expected.to permit_params(domains_params) }
      it { is_expected.not_to permit_params(account_params) }
    end
  end

  def permit_params(values)
    permit(*values).for(controller.action_name, verb: :put, params: params)
                   .on(:account)
  end
end
