require 'rails_helper'

describe Campaign, type: :model do
  before do
    allow_any_instance_of(DomainValidator).to receive(:validate_each)
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :subject }
  it { is_expected.to validate_presence_of :from_name }
  it { is_expected.to validate_presence_of :from_email }
  it { is_expected.to allow_value('jonh@doe.com').for :from_email }
  it { is_expected.not_to allow_value('asdf.com').for :from_email }

  it { is_expected.to belong_to :account }
  it { is_expected.to have_db_index :account_id }
  it { is_expected.to have_db_index([:name, :account_id]).unique }
  it { is_expected.to have_many :messages }

  it { is_expected.not_to have_db_column :messages_count }
  it { is_expected.to have_db_column(:recipients_count).of_type :integer }
  it { is_expected.to have_db_column(:unique_opens_count).of_type :integer }
  it { is_expected.to have_db_column(:unique_clicks_count).of_type :integer }
  it { is_expected.to have_db_column(:bounces_count).of_type :integer }
  it { is_expected.to have_db_column(:complaints_count).of_type :integer }
  it { is_expected.to have_db_column(:state).of_type :integer }
  it { is_expected.to have_db_column(:send_settings).of_type :jsonb }
  it { is_expected.to have_db_column(:trigger_settings).of_type :jsonb }
  it do
    is_expected.to have_db_column(:type).of_type(:string)
      .with_options(default: '', null: false)
  end

  it { is_expected.to delegate_method(:aws_options).to(:account).with_prefix }
  it { is_expected.to delegate_method(:domain_names).to(:account).with_prefix }
  it { is_expected.to delegate_method(:expired?).to(:account).with_prefix }
  it { is_expected.to delegate_method(:count).to(:messages).with_prefix }

  it { is_expected.to strip_attribute :name }
  it { is_expected.to strip_attribute :subject }
  it { is_expected.to strip_attribute :from_name }
  it { is_expected.to strip_attribute :from_email }

  it do
    is_expected.to define_enum_for(:state)
      .with([:draft, :queued, :scheduled, :sending, :paused, :sent])
  end

  it { expect(described_class).to respond_to(:sort).with(1).argument }
  it { expect(described_class).to respond_to(:recent).with(0).arguments }

  describe '#deliveries_count' do
    it 'calculates current deliveries count' do
      expect(subject).to receive(:recipients_count).and_return(1_000)
      expect(subject).to receive(:messages_count).and_return(2_000)
      expect(subject.deliveries_count).to eq(1_000)
    end
  end

  describe '#unsent_count' do
    it 'calculates remaining messages to be sent' do
      expect(subject).to receive(:recipients_count).and_return(1_000)
      expect(subject).to receive(:messages_count).and_return(1_100)
      expect(subject.unsent_count).to be_zero
    end
  end

  describe '#from' do
    it 'concatenates from_name and from_email fields' do
      campaign = Fabricate.build(:campaign)
      from = "#{campaign.from_name} <#{campaign.from_email}>"
      expect(campaign.from).to eq(from)
    end
  end

  describe '#from?' do
    it 'verifies presence of from name and from email columns' do
      campaign = Fabricate.build :campaign

      expect(campaign).to_not be_blank
      expect(campaign).to_not be_blank
      expect(campaign).to be_from

      campaign.from_name = nil
      expect(campaign).not_to be_from
    end
  end

  describe '#duplicate' do
    it 'duplicates current record' do
      campaign = Fabricate.build(:sent_campaign)

      expect_any_instance_of(Campaign).to receive(:assign_attributes)
        .with(sent_at: nil,
              recipients_count: 0,
              unique_opens_count: 0,
              unique_clicks_count: 0,
              bounces_count: 0,
              complaints_count: 0,
              state: Campaign.states[:draft],
              send_settings: {},
              trigger_settings: {})

      campaign_copy = campaign.duplicate

      expect(campaign_copy.name).to end_with 'copy'
      expect(campaign_copy).not_to be_persisted
    end
  end

  describe '#validate_from_field' do
    it 'validates format of from virtual attribute' do
      subject.from_name = 'Jonh <x.'
      subject.from_email = 'jonh@doe.com'

      expect(subject).to_not be_valid
      expect(subject.errors).to have_key(:from_name)
      expect(subject.errors.get(:from_name))
        .to include t('activerecord.errors.models.campaign.unstructured_from')
    end
  end

  describe '#set_default_state' do
    it 'sets default state' do
      expect(subject.state).to be_nil
      subject.run_callbacks :create
      expect(subject).to be_draft
    end
  end
end
