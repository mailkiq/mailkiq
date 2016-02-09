require 'rails_helper'

describe Campaign, type: :model do
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

  describe '#unique_opens_count' do
    it 'number of unique opens for the campaign' do
      campaign = Fabricate.build(:campaign)
      expect(campaign).to receive_message_chain(:messages, :opened, :count)
      campaign.unique_opens_count
    end
  end

  describe '#unique_clicks_count' do
    it 'number of uniques clicks for the campaign' do
      campaign = Fabricate.build(:campaign)
      expect(campaign).to receive_message_chain(:messages, :clicked, :count)
      campaign.unique_clicks_count
    end
  end
end
