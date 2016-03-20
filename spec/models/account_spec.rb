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
  it { is_expected.to have_many(:campaigns).dependent :destroy }
  it { is_expected.to have_many(:subscribers).dependent :delete_all }
  it { is_expected.to have_many(:tags).dependent :delete_all }
  it { is_expected.to have_many(:domains).dependent :destroy }
  it { is_expected.to belong_to(:plan) }

  it { is_expected.to delegate_method(:domain_names).to(:domains) }

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
