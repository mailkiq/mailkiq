require 'rails_helper'

describe Tag, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to belong_to :account }
  it { is_expected.to have_many(:taggings).dependent :restrict_with_error }
  it { is_expected.to have_many(:subscribers).through :taggings }

  it 'validates unique name scoped to account' do
    expect_any_instance_of(AccessKeysValidator).to receive(:validate)
      .at_least(:once)
      .and_return(true)

    Fabricate.create :tag

    is_expected.to validate_uniqueness_of(:slug)
      .scoped_to(:account_id)
      .case_insensitive
  end

  describe '#set_slug' do
    it 'parameterize name before validation' do
      tag = described_class.new name: 'Comprou eBook'
      tag.valid?
      expect(tag.slug).to eq('comprou-ebook')
    end
  end
end
