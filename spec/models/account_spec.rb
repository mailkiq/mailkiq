require 'rails_helper'

describe Account, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_inclusion_of(:language).in_array Account::LANGUAGES }
  it { is_expected.to validate_inclusion_of(:aws_region).in_array Account::REGIONS }
  it { is_expected.to allow_value('Asia/Yakutsk').for :time_zone }
  it { is_expected.not_to allow_value('anything').for :time_zone }
  it { is_expected.to allow_value('jonh@doe.com').for :email }
  it { is_expected.not_to allow_value('asdf.com').for :email }

  it { is_expected.to have_db_index(:email).unique }
  it { is_expected.to have_many(:lists).dependent :destroy }
  it { is_expected.to have_many(:campaigns).dependent :destroy }
  it { is_expected.to have_many(:templates).dependent :destroy }
  it { is_expected.to have_many(:subscribers).dependent :destroy }

  context 'invalid credentials', vcr: { cassette_name: :invalid_token } do
    it 'append error message to AWS Access key ID attribute' do
      account = Fabricate.build(:account)
      error_message = I18n.t('activerecord.errors.models.account.invalid_token')
      expect(account).not_to be_valid
      expect(account.errors.keys).to eq([:aws_access_key_id])
      expect(account.errors.messages[:aws_access_key_id]).to include(error_message)
    end
  end
end
