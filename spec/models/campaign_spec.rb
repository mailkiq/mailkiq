require 'rails_helper'

describe Campaign, type: :model do
  before do
    allow_any_instance_of(DomainValidator).to receive(:validate_each)
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :subject }
  it { is_expected.to validate_presence_of :from_name }
  it { is_expected.to validate_presence_of :from_name }
  it { is_expected.to validate_presence_of :html_text }
  it { is_expected.to allow_value('jonh@doe.com').for :from_email }
  it { is_expected.not_to allow_value('asdf.com').for :from_email }

  it { is_expected.to belong_to :account }
  it { is_expected.to have_db_index :account_id }
  it { is_expected.to have_many(:messages).dependent :delete_all }
  it { is_expected.to have_db_column(:recipients_count).of_type :integer }
  it { is_expected.to have_db_column(:unique_opens_count).of_type :integer }
  it { is_expected.to have_db_column(:unique_clicks_count).of_type :integer }

  it { is_expected.to delegate_method(:credentials).to(:account).with_prefix }
  it { is_expected.to delegate_method(:domain_names).to(:account).with_prefix }

  it { expect(described_class).to respond_to(:sort).with(2).arguments }
  it { expect(described_class).to respond_to(:recents) }

  describe '#sender' do
    it 'concatenates from_name and from_email fields' do
      campaign = Fabricate.build(:campaign)
      sender = "#{campaign.from_name} <#{campaign.from_email}>"
      expect(campaign.sender).to eq(sender)
    end
  end

  describe '#queue_name' do
    it 'sidekiq queue name' do
      campaign = Fabricate.build(:campaign, id: 1)
      expect(campaign.queue_name).to eq('campaign-1')
    end
  end
end
