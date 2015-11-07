require 'rails_helper'

describe CustomField, type: :model do
  it { is_expected.to validate_presence_of :field_name }
  it { is_expected.to validate_length_of(:field_name).is_at_most(30) }
  it { is_expected.to validate_presence_of :data_type }
  it { is_expected.to define_enum_for(:data_type).with [:text, :number, :date] }
  it { is_expected.to_not allow_value('naMe').for(:field_name) }
  it { is_expected.to_not allow_value('Email').for(:field_name) }

  it { is_expected.to belong_to :list }
  it { is_expected.to have_db_index :list_id }
  it { is_expected.to have_db_index([:field_name, :list_id]).unique }

  describe '#set_key' do
    it 'parameterize field name before validation' do
      field = described_class.new field_name: 'Postal Code'
      expect(field).to be_valid
      expect(field.key).to eq('postal_code')
    end
  end
end
