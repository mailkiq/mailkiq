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
  it { is_expected.to delegate_method(:credentials).to(:account).with_prefix }

  it { expect(described_class).to respond_to :succeed }

  it 'validate uniqueness of domain name' do
    expect_any_instance_of(AccessKeysValidator).to receive(:validate)
      .at_least(2)
      .and_return(true)

    expect_any_instance_of(Domain).to receive(:verify_domain_identity)
      .and_return(true)

    Fabricate.create :domain

    is_expected.to validate_uniqueness_of(:name).case_insensitive
  end

  describe '#txt_name' do
    it 'return TXT record name' do
      domain = Domain.new name: 'patriotas.net'
      expect(domain.txt_name).to eq('_amazonses.patriotas.net')
    end
  end

  describe '#txt_value' do
    it 'alias to verification_token' do
      domain = Domain.new verification_token: 'blah'
      expect(domain.txt_value).to eq(domain.verification_token)
    end
  end

  describe '#save_verification_attributes!',
           vcr: { cassette_name: :get_identity_verification_attributes } do
    it 'fetch verification status on Amazon SES' do
      verification_token = 'oPld11CtXSBGVTVgv6DFtRe2EdmM5I6R6OfADMQ++kQ='
      account = Fabricate.build(:valid_account)
      domain = Domain.new name: 'thoughtplane.com', account: account

      expect(domain).to receive(:status=).with(Domain.statuses[:success])
      expect(domain).to receive(:verification_token=).with(verification_token)
      expect(domain).to receive(:save!)

      domain.save_verification_attributes!
    end
  end

  describe '#verify_domain_identity',
           vcr: { cassette_name: :verify_domain_identity } do
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

  describe '#delete_identity', vcr: { cassette_name: :delete_identity } do
    it 'remove domain identity on Amazon SES' do
      account = Fabricate.build :valid_account
      domain = Domain.new name: 'patriotas.net', account: account
      response = domain.send(:delete_identity)
      expect(response.status).to eq(200)
    end
  end
end
