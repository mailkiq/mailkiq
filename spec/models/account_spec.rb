require 'rails_helper'

describe Account, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :plan }
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

  it { is_expected.to belong_to :plan }
  it { is_expected.to have_db_index(:email).unique }
  it { is_expected.to have_many :campaigns }
  it { is_expected.to have_many :subscribers }
  it { is_expected.to have_many :tags }
  it { is_expected.to have_many(:domains).dependent :destroy }

  it { is_expected.to delegate_method(:domain_names).to(:domains) }
  it { is_expected.to delegate_method(:credits).to(:plan).with_prefix }
  it { is_expected.to delegate_method(:remaining).to(:quota).with_prefix }
  it { is_expected.to delegate_method(:exceed?).to(:quota).with_prefix }

  it { is_expected.to have_attr_accessor :force_password_validation }
  it { is_expected.to have_attr_accessor :paypal_payment_token }

  it { is_expected.to have_counter :used_credits }

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
      subject.aws_access_key_id = secrets[:mailkiq_access_key_id]
      subject.aws_secret_access_key = secrets[:mailkiq_secret_access_key]
      expect(subject).to be_tied_to_mailkiq

      subject.aws_access_key_id = 'blah'
      expect(subject).not_to be_tied_to_mailkiq
    end
  end

  describe '#aws_options' do
    it 'returns options to initialize Aws services' do
      options = subject.aws_options
      expect(options).to be_instance_of HashWithIndifferentAccess
      expect(options).to have_key :access_key_id
      expect(options).to have_key :secret_access_key
      expect(options).to have_key :region
      expect(options).to have_key :stub_responses
      expect(options.size).to eq(4)
    end
  end

  describe '#mixpanel_properties' do
    it 'returns MixPanel profile properties' do
      properties = subject.mixpanel_properties
      expect(properties.keys.size).to eq(4)
      expect(properties).to have_key :$first_name
      expect(properties).to have_key :$last_name
      expect(properties).to have_key :$created
      expect(properties).to have_key :$email
    end
  end
end
