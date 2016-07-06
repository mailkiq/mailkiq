require 'rails_helper'

RSpec.describe Domain, type: :model do
  it { is_expected.to validate_presence_of :name }
  it do
    is_expected.to define_enum_for(:verification_status)
      .with([:pending, :success, :failed, :temporary_failure, :not_started])
  end

  it do
    is_expected.to define_enum_for(:dkim_verification_status)
      .with([:pending, :success, :failed, :temporary_failure, :not_started])
  end

  it do
    is_expected.to define_enum_for(:mail_from_domain_status)
      .with([:pending, :success, :failed, :temporary_failure, :not_started])
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
    it 'changes statuses to pending' do
      expect(subject.verification_status).to be_nil
      expect(subject.dkim_verification_status).to be_nil
      expect(subject.mail_from_domain_status).to be_nil

      subject.all_pending!

      expect(subject).to be_pending
      expect(subject).to be_dkim_pending
      expect(subject).to be_mail_from_pending
    end
  end
end
