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
    it do
      is_expected.to permit(:name)
        .for(:create, params: { domain: { name: 'patriotras.net' } })
        .on(:domain)
    end
  end

  describe 'DELETE /domains/:id', vcr: { cassette_name: :delete_identity } do
    before do
      domain = Domain.new name: 'patriotas.net', account: account

      expect(domain).to receive(:destroy)
      expect(account).to receive_message_chain(:domains, :find)
        .and_return(domain)

      delete :destroy, id: 1
    end

    it { is_expected.to use_before_action :require_login }
    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to amazon_settings_path }
  end
end
