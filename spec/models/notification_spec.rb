require 'rails_helper'

describe Notification, type: :model do
  it { is_expected.to have_db_column(:data).of_type :jsonb }
  it { is_expected.to have_db_column(:message_uid).of_type :string }
  it { is_expected.to have_db_index :message_uid }
  it do
    is_expected.to belong_to(:message)
      .with_foreign_key(:message_uid)
      .with_primary_key(:uid)
  end

  it do
    is_expected.to define_enum_for(:type)
      .with([:bounce, :complaint, :delivery])
  end

  describe '.inheritance_column' do
    it 'disable STI feature' do
      expect(described_class.inheritance_column).to be_nil
    end
  end
end
