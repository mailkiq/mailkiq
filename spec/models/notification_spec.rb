require 'rails_helper'

describe Notification, type: :model do
  it { is_expected.to have_db_column(:data).of_type :jsonb }
  it { is_expected.to belong_to :message }
  it do
    is_expected.to define_enum_for(:type).with([:bounce, :complaint, :delivery])
  end

  describe '.inheritance_column' do
    it { expect(described_class.inheritance_column).to be_nil }
  end
end
