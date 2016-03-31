require 'rails_helper'

describe Tag, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to belong_to :account }
  it { is_expected.to have_many(:taggings).dependent :restrict_with_error }
  it { is_expected.to have_many(:subscribers).through :taggings }
  it { is_expected.to have_db_index([:slug, :account_id]).unique }

  describe '#set_slug' do
    it 'sets slug with parameterized name' do
      tag = described_class.new name: 'Comprou eBook'
      tag.send(:set_slug)
      expect(tag.slug).to eq('comprou-ebook')
    end
  end
end
