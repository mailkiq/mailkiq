require 'rails_helper'

describe DomainsController, type: :controller do
  let(:account) { Fabricate.build :valid_account }

  before do
    sign_in_as account
  end

  describe 'POST /domains', vcr: { cassette_name: :verify_domain_identity } do
    before do
      allow_any_instance_of(Domain).to receive(:save)
      post :create, domain: { name: 'patriotras.net' }
    end

    it { is_expected.to use_before_action :require_login }
    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to amazon_settings_path }
    it { is_expected.to set_flash[:notice] }
    it do
      is_expected.to permit(:name)
        .for(:create, params: { domain: { name: 'patriotras.net' } })
        .on(:domain)
    end

    it 'verifies a domain' do
      domain = assigns(:domain)
      expect(domain.status).to eq('pending')
      expect(domain.verification_token)
        .to eq('3RPd+UgYrwcWA3+fygXo5LqqMzLAEcK9KOD7EVpVMTs=')
    end
  end

  describe 'DELETE /domains/:id', vcr: { cassette_name: :delete_identity } do
    before do
      domain = Domain.new name: 'patriotas.net', account: account

      expect(controller.ses).to receive(:delete_identity).with('patriotas.net')
      expect(domain).to receive(:destroy)
      expect(account).to receive_message_chain(:domains, :find)
        .and_return(domain)

      delete :destroy, id: 1
    end

    it { is_expected.to use_before_action :require_login }
    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to amazon_settings_path }
    it { is_expected.to set_flash[:notice] }
  end
end
