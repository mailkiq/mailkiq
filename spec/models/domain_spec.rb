require 'rails_helper'

describe Domain, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :verification_token }
  it { is_expected.to validate_presence_of :status }
  it do
    is_expected.to define_enum_for(:status).with([
      :pending, :success, :failed, :temporary_failure, :not_started
    ])
  end

  it { is_expected.to belong_to :account }
  it { is_expected.to delegate_method(:credentials).to :account }

  describe '#verify_domain_identity', vcr: { cassette_name: :verify_domain_identity } do
    it 'verify a new domain on before create callback' do
      account = Fabricate.build :valid_account
      domain = Domain.new name: 'patriotas.net', account: account

      expect(domain.status).to be_nil
      expect(domain.verification_token).to be_nil

      domain.send(:verify_domain_identity)

      expect(domain.status).to eq('pending')
      expect(domain.verification_token)
        .to eq('3RPd+UgYrwcWA3+fygXo5LqqMzLAEcK9KOD7EVpVMTs=')
    end
  end

  describe '#delete_identity' do
    it 'remove domain from ses' do
    end
  end
end
