require 'rails_helper'

describe Tag, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to belong_to :account }
  it { is_expected.to have_many(:taggings).dependent :restrict_with_error }
  it { is_expected.to have_many(:subscribers).through :taggings }
  it { is_expected.to have_db_index([:slug, :account_id]).unique }
  it { is_expected.to delegate_method(:count).to(:subscribers).with_prefix }

  it 'paginates 10 records per page' do
    expect(described_class.default_per_page).to eq(10)
  end

  describe '#set_slug' do
    it 'sets slug to parameterized name' do
      tag = described_class.new name: 'Comprou eBook'
      tag.send(:set_slug)
      expect(tag.slug).to eq('comprou-ebook')
    end
  end
end
