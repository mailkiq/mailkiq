require 'rails_helper'

describe Automation, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to belong_to :account }
  it { is_expected.to belong_to :campaign }
  it { is_expected.to have_db_column(:name).of_type :citext }
  it { is_expected.to have_db_index(:name).unique }
  it do
    is_expected.to have_db_column(:conditions).of_type(:jsonb)
      .with_options(null: false, default: {})
  end

  it { is_expected.to accept_nested_attributes_for :campaign }
end
