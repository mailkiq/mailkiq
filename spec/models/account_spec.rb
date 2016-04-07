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

  it { is_expected.to have_db_index(:email).unique }
  it { is_expected.to have_many(:campaigns).dependent :destroy }
  it { is_expected.to have_many(:subscribers).dependent :delete_all }
  it { is_expected.to have_many(:tags).dependent :delete_all }
  it { is_expected.to have_many(:domains).dependent :destroy }
  it { is_expected.to belong_to(:plan) }

  it { is_expected.to delegate_method(:domain_names).to(:domains) }
  it { is_expected.to delegate_method(:credits).to(:plan).with_prefix }
  it { is_expected.to delegate_method(:remaining).to(:credits).with_prefix }
  it { is_expected.to delegate_method(:exceed?).to(:credits).with_prefix }

  it { is_expected.to have_attr_accessor :force_password_validation }
  it { is_expected.to have_attr_accessor :paypal_payment_token }

  it { is_expected.to have_counter :used_credits }

  describe '#tied_to_mailkiq?' do
    it 'verifies if account is tied to the official SES account' do
      subject.aws_access_key_id = ENV['MAILKIQ_ACCESS_KEY_ID']
      subject.aws_secret_access_key = ENV['MAILKIQ_SECRET_ACCESS_KEY']
      expect(subject).to be_tied_to_mailkiq

      subject.aws_access_key_id = 'blah'
      expect(subject).not_to be_tied_to_mailkiq
    end
  end

  describe '#admin?' do
    it 'verifies if account is an administrator' do
      account = described_class.new email: 'rainerborene@gmail.com'
      expect(account).to be_admin

      account.email = 'blah@blah.com'
      expect(account).to_not be_admin
    end
  end

  describe '#credentials' do
    it 'returns credentials to initialize Fog::AWS services' do
      credentials = subject.credentials
      expect(credentials).to be_instance_of HashWithIndifferentAccess
      expect(credentials).to have_key :access_key_id
      expect(credentials).to have_key :secret_access_key
      expect(credentials).to have_key :region
      expect(credentials.size).to eq(3)
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
