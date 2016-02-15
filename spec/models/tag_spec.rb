require 'rails_helper'

describe Tag, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to belong_to :account }
  it { is_expected.to have_many(:taggings).dependent :delete_all }
  it { is_expected.to have_many(:subscribers).through :taggings }

  describe '#set_slug' do
    it 'parameterize name before validation' do
      tag = described_class.new name: 'Comprou eBook'
      tag.valid?
      expect(tag.slug).to eq('comprou-ebook')
    end
  end
end
