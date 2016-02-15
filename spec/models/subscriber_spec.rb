require 'rails_helper'

describe Subscriber, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to allow_value('jonh@doe.com').for :email }
  it { is_expected.not_to allow_value('asdf.com').for :email }
  it do
    is_expected.to define_enum_for(:state)
      .with(%i(active unconfirmed unsubscribed bounced complained deleted))
  end

  it { is_expected.to have_db_index :account_id }
  it { is_expected.to have_db_index :custom_fields }
  it { is_expected.to have_db_index([:account_id, :email]).unique }
  it { is_expected.to belong_to :account }
  it { is_expected.to have_many(:messages).dependent :delete_all }
  it { is_expected.to have_many(:taggings).dependent :delete_all }
  it { is_expected.to have_many(:tags).through :taggings }
  it do
    is_expected.to have_db_column(:custom_fields)
      .of_type(:jsonb).with_options(null: false, default: {})
  end

  describe '#first_name' do
    it 'returns subscriber first name' do
      subscriber = Fabricate.build(:subscriber)
      expect(subscriber.first_name).to eq('Rainer')
    end
  end

  describe '#last_name' do
    it 'returns subscriber last name' do
      subscriber = Fabricate.build(:subscriber)
      expect(subscriber.last_name).to eq('Borene')
    end
  end

  describe '#interpolations' do
    it 'attributes for mailer' do
      interpolations = Fabricate.build(:subscriber).interpolations
      expect(interpolations).to have_key :first_name
      expect(interpolations).to have_key :last_name
      expect(interpolations).to have_key :full_name
      expect(interpolations.size).to eq(3)
    end
  end
end
