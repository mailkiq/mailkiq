require 'rails_helper'

describe Account, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to allow_value('Asia/Yakutsk').for :time_zone }
  it { is_expected.not_to allow_value('anything').for :time_zone }
  it { is_expected.to allow_value('jonh@doe.com').for :email }
  it { is_expected.not_to allow_value('asdf.com').for :email }
  it do
    is_expected.to validate_inclusion_of(:language).in_array Account::LANGUAGES
  end
  it do
    is_expected.to validate_inclusion_of(:aws_region).in_array Account::REGIONS
  end

  it { is_expected.to have_db_index(:email).unique }
  it { is_expected.to have_many(:domains).dependent :destroy }
  it { is_expected.to have_many :campaigns }
  it { is_expected.to have_many :subscribers }
  it { is_expected.to have_many :tags }
  it { is_expected.to have_many :automations }

  it { is_expected.to delegate_method(:domain_names).to(:domains) }
  it { is_expected.to delegate_method(:remaining).to(:quota).with_prefix }
  it { is_expected.to delegate_method(:exceed?).to(:quota).with_prefix }

  it { is_expected.to have_attr_accessor :force_password_validation }
  it { is_expected.to have_attr_accessor :force_plan_validation }
  it { is_expected.to have_attr_accessor :credit_card_token }
  it { is_expected.to have_attr_accessor :plan }

  describe '.new_with_session' do
    it 'sets default values for new accounts' do
      account = described_class.new_with_session({}, {})
      secrets = Rails.application.secrets

      expect(account.language).to eq('pt-BR')
      expect(account.time_zone).to eq('Brasilia')
      expect(account.aws_access_key_id).to eq(secrets[:aws_access_key_id])
      expect(account.aws_secret_access_key)
        .to eq(secrets[:aws_secret_access_key])
    end
  end

  describe '#expired?' do
    it 'verifies expiration time' do
      subject.expires_at = 1.day.ago
      expect(subject).to be_expired

      subject.expires_at = Time.now
      expect(subject).to be_expired

      subject.expires_at = Time.now + 1.day
      expect(subject).not_to be_expired
    end
  end

  describe '#remember_me' do
    it 'always remember the user' do
      expect(subject.remember_me).to be_truthy
    end
  end

  describe '#password_required?' do
    it 'requires password presence when needed' do
      subject.force_password_validation = true
      expect(subject).to be_password_required

      subject.force_password_validation = false
      expect(subject).to receive(:persisted?).and_return(true)
      expect(subject).not_to be_password_required
    end
  end

  describe '#tied_to_mailkiq?' do
    it 'verifies if account is tied to the official SES account' do
      secrets = Rails.application.secrets
      subject.aws_access_key_id = secrets[:aws_access_key_id]
      subject.aws_secret_access_key = secrets[:aws_secret_access_key]
      expect(subject).to be_tied_to_mailkiq

      subject.aws_access_key_id = 'blah'
      expect(subject).not_to be_tied_to_mailkiq
    end
  end

  describe '#aws_options' do
    it 'returns options to initialize Aws services' do
      options = subject.aws_options
      expect(options).to be_instance_of HashWithIndifferentAccess
      expect(options[:access_key_id]).to eq(subject.aws_access_key_id)
      expect(options[:secret_access_key]).to eq(subject.aws_secret_access_key)
      expect(options[:region]).to eq(subject.aws_region || 'us-east-1')
      expect(options[:stub_responses]).to be_truthy
      expect(options.size).to eq(4)
    end
  end

  describe '#iugu?' do
    it 'checks presence of Iugu attributes' do
      expect(subject.iugu_customer_id).to be_nil
      expect(subject.iugu_subscription_id).to be_nil
      expect(subject).to_not be_iugu

      subject.iugu_customer_id = SecureRandom.uuid
      subject.iugu_subscription_id = SecureRandom.uuid
      expect(subject).to be_iugu
    end
  end

  describe '#validate_plan' do
    it 'validates plan with Iugu API' do
      subject.force_plan_validation = true
      subject.plan = 'basic'

      expect(Iugu::Plan).to receive(:fetch_by_identifier).with(subject.plan)
        .and_raise(Iugu::ObjectNotFound)

      expect(subject).not_to be_valid
      expect(subject.errors[:base].join).to include('invalid_plan')
    end
  end
end
