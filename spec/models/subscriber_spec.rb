require 'rails_helper'

describe Subscriber, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to allow_value('jonh@doe.com').for :email }
  it { is_expected.not_to allow_value('asdf.com').for :email }

  it { is_expected.to belong_to :account }
  it { is_expected.to have_many(:subscriptions).dependent :delete_all }
  it { is_expected.to have_many(:lists).through :subscriptions }
  it { is_expected.to have_db_index :account_id }
  it { is_expected.to have_db_index :custom_fields }
  it { is_expected.to have_db_index([:account_id, :email]).unique }
  it do
    is_expected.to have_db_column(:custom_fields).
      of_type(:jsonb).with_options(null: false, default: {})
  end
end
