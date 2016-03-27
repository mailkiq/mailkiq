require 'rails_helper'

describe Domain, type: :model do
  it { is_expected.to validate_presence_of :name }
  it do
    is_expected.to define_enum_for(:status)
      .with([:pending, :success, :failed, :temporary_failure, :not_started])
  end

  it { is_expected.to have_db_index(:name).unique }
  it { is_expected.to belong_to :account }
  it { is_expected.to delegate_method(:verify!).to(:identity).with_prefix }
  it { is_expected.to delegate_method(:delete!).to(:identity).with_prefix }

  context 'scopes' do
    it { expect(described_class).to respond_to :succeed }
  end

  describe '#identity' do
    it 'creates a sort of proxy object between SES API and current model' do
      account = Fabricate.build :valid_account
      subject.account = account
      expect(subject.identity).to be_instance_of DomainIdentity
    end
  end

  describe '#txt_name' do
    it 'returns the TXT record name' do
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

  describe '#cname_records' do
    it 'generates fully-formed DNS records for use with DKIM' do
      domain = Fabricate.build :domain
      record = Domain::CNAME.new(
        'a._domainkey.patriotas.net',
        'a.dkim.amazonses.com'
      )

      expect(domain.cname_records).to include(record)
    end
  end
end
