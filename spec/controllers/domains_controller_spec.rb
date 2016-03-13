require 'rails_helper'

describe DomainsController, type: :controller do
  let(:account) { Fabricate.build :valid_account }

  before do
    sign_in_as account
  end

  describe 'POST /domains', vcr: { cassette_name: :verify_domain } do
    before do
      allow_any_instance_of(Domain).to receive(:save)
      allow_any_instance_of(Domain).to receive(:transaction).and_yield
      post :create, domain: { name: 'patriotas.net' }
    end

    it { is_expected.to use_before_action :require_login }
    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to amazon_settings_path }
    it { is_expected.to set_flash[:notice] }
    it do
      is_expected.to permit(:name)
        .for(:create, params: { domain: { name: 'patriotas.net' } })
        .on(:domain)
    end

    it 'verify a new domain on Amazon SES' do
      domain = assigns(:domain)
      expect(domain.status).to eq('pending')
      expect(domain.verification_token.size).to eq(44)
      expect(domain.dkim_tokens.size).to eq(3)
    end
  end

  describe 'DELETE /domains/:id', vcr: { cassette_name: :delete_identity } do
    before do
      domain = Domain.new name: 'patriotas.net', account: account

      expect(domain).to receive(:transaction).and_yield
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
