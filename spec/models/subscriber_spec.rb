require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to allow_value('john@doe.com').for :email }
  it { is_expected.not_to allow_value('asdf.com').for :email }
  it do
    is_expected.not_to allow_value('franrodrigues1962@.gmail..com').for :email
  end
  it do
    is_expected.to define_enum_for(:state)
      .with(%i(active unconfirmed unsubscribed bounced complained deleted
               invalid_email))
  end

  it { is_expected.to have_db_index :account_id }
  it { is_expected.to have_db_index :custom_fields }
  it { is_expected.to have_db_index([:account_id, :email]).unique }
  it { is_expected.to belong_to :account }
  it { is_expected.to have_many :messages }
  it { is_expected.to have_many :taggings }
  it { is_expected.to have_many(:tags).through :taggings }
  it do
    is_expected.to have_db_column(:custom_fields)
      .of_type(:jsonb).with_options(null: false, default: {})
  end

  it { is_expected.to strip_attribute :name }
  it { is_expected.to strip_attribute :email }

  context 'scopes' do
    it { expect(described_class).to respond_to(:recent).with(0).arguments }
    it { expect(described_class).to respond_to(:activated).with(0).arguments }
    it { expect(described_class).to respond_to(:sort).with(1).argument }
  end

  it { expect(described_class.ancestors).to include Person }

  it 'paginates 10 records per page' do
    expect(described_class.default_per_page).to eq(10)
  end

  describe '#subscribe!' do
    it 'changes subscriber state to active' do
      expect(subject).to receive(:update!)
        .with(unsubscribed_at: nil, state: :active)

      subject.subscribe!
    end
  end

  describe '#unsubscribe!' do
    it 'changes subscriber state to unsubscribed' do
      travel_to 1.year.ago do
        expect(subject).to receive(:update!)
          .with(unsubscribed_at: Time.now, state: :unsubscribed)

        subject.unsubscribe!
      end
    end
  end

  describe '#subscription_token' do
    it 'generates an unsubscription token' do
      expect(subject.subscription_token).to eq Token.encode(subject.id)
    end
  end

  describe '#interpolations' do
    it 'generates a custom attributes hash' do
      interpolations = subject.interpolations
      expect(interpolations).to have_key :first_name
      expect(interpolations).to have_key :last_name
      expect(interpolations).to have_key :full_name
      expect(interpolations.size).to eq(3)
    end
  end

  describe '#set_default_state' do
    it 'sets state to unconfirmed' do
      expect(subject.state).to be_nil
      subject.run_callbacks :create
      expect(subject).to be_unconfirmed
    end
  end
end
