require 'rails_helper'

describe Domain, type: :model do
  it { is_expected.to validate_presence_of :name }
  it do
    is_expected.to define_enum_for(:verification_status)
      .with([:pending, :success, :failed, :temporary_failure, :not_started])
  end

  it do
    is_expected.to define_enum_for(:dkim_verification_status)
      .with([:dkim_pending, :dkim_success, :dkim_failed,
             :dkim_temporary_failure, :dkim_not_started])
  end

  it do
    is_expected.to define_enum_for(:mail_from_domain_status)
      .with([:mail_from_pending, :mail_from_success, :mail_from_failed,
             :mail_from_temporary_failure])
  end

  it { is_expected.to have_db_index(:name).unique }
  it { is_expected.to belong_to :account }
  it { is_expected.to delegate_method(:verify!).to(:identity).with_prefix }
  it { is_expected.to delegate_method(:update!).to(:identity).with_prefix }
  it { is_expected.to delegate_method(:delete!).to(:identity).with_prefix }
  it { is_expected.to delegate_method(:aws_options).to(:account).with_prefix }
  it { is_expected.to delegate_method(:aws_topic_arn).to(:account).with_prefix }

  context 'scopes' do
    it { expect(described_class).to respond_to :succeed }
  end

  describe '#identity' do
    it 'creates a domain identity object' do
      expect(DomainIdentity).to receive(:new).with(subject)
      subject.identity
    end
  end

  describe '#records' do
    it 'creates a object that represents DNS records' do
      expect(DomainRecords).to receive(:new).with(subject)
      subject.records
    end
  end

  describe '#all_pending!' do
    it 'makes all statuses pending' do
      expect(subject).to receive(:verification_status=).with(:pending)
      expect(subject).to receive(:dkim_verification_status=).with(:dkim_pending)
      expect(subject).to receive(:mail_from_domain_status=)
        .with(:mail_from_pending)

      subject.all_pending!
    end
  end
end
