require 'rails_helper'

RSpec.describe Message, type: :model do
  it { is_expected.to belong_to :subscriber }
  it { is_expected.to belong_to :campaign }
  it do
    is_expected.to belong_to(:automation).class_name('Automation')
      .with_foreign_key(:campaign_id)
      .counter_cache(:recipients_count)
  end
  it { is_expected.to have_many :notifications }
  it do
    is_expected.to define_enum_for(:state)
      .with([:pending, :bounce, :complaint, :delivery])
  end

  it { is_expected.to delegate_method(:name).to(:campaign).with_prefix }
  it { is_expected.to delegate_method(:html_text).to(:campaign) }
  it { is_expected.to delegate_method(:plain_text).to(:campaign) }
  it { is_expected.to delegate_method(:subscription_token).to(:subscriber) }

  describe '#save_with_uuid!' do
    it 'saves record with assigned uuid and sent_at attributes' do
      travel_to Time.now do
        expect(subject).to receive(:assign_attributes)
          .with(uuid: 'uuid', sent_at: Time.now)
        expect(subject).to receive(:save!)

        subject.save_with_uuid! 'uuid'
      end
    end
  end

  describe '#generate_token' do
    it 'generates token on after initialize callback' do
      expect(subject.token.size).to eq(32)
    end
  end
end
