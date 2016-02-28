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
  it do
    is_expected.to accept_nested_attributes_for(:domains).allow_destroy(true)
  end

  it { is_expected.to have_db_index(:email).unique }
  it { is_expected.to have_many(:campaigns).dependent :destroy }
  it { is_expected.to have_many(:subscribers).dependent :delete_all }
  it { is_expected.to have_many(:tags).dependent :delete_all }
  it { is_expected.to have_many(:domains).dependent :destroy }
  it { is_expected.to belong_to(:plan) }

  it { is_expected.to delegate_method(:domain_names).to(:domains) }

  context 'invalid credentials', vcr: { cassette_name: :invalid_token } do
    it 'append error message to AWS Access key ID attribute' do
      account = Fabricate.build(:account)
      error_message = I18n.t('activerecord.errors.models.account.invalid_token')
      expect(account).not_to be_valid
      expect(account.errors.keys).to eq([:aws_access_key_id])
      expect(account.errors.messages[:aws_access_key_id])
        .to include(error_message)
    end
  end

  describe '#credentials' do
    it 'return options to initialize Fog::AWS services' do
      credentials = subject.credentials
      expect(credentials).to be_instance_of HashWithIndifferentAccess
      expect(credentials).to have_key :aws_access_key_id
      expect(credentials).to have_key :aws_secret_access_key
      expect(credentials).to have_key :region
      expect(credentials.size).to eq(3)
    end
  end

  describe '#admin?' do
    it 'God please give me the necessary power to run the world' do
      account = described_class.new email: 'rainerborene@gmail.com'
      expect(account).to be_admin

      account.email = 'blah@blah.com'
      expect(account).to_not be_admin
    end
  end
end
