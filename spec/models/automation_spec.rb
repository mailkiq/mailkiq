require 'rails_helper'

describe Automation, type: :model do
  it 'removes inherited default scope' do
    expect(described_class.default_scopes).to be_empty
  end

  describe '#send_type' do
    it 'returns send type' do
      subject.send_settings['type'] = 'zzz'
      expect(subject.send_type).to eq('zzz')
    end
  end

  describe '#send_type=' do
    it 'sets send type attribute' do
      subject.send_type = 'zzz'
      expect(subject.send_settings['type']).to eq('zzz')
    end
  end

  describe '#subscription_confirmation?' do
    it 'checks automated campaign type' do
      subject.send_type = 'subscription_confirmation'
      expect(subject).to be_subscription_confirmation
    end
  end

  describe '#require_subscribe_url' do
    it 'requires subscribe_url variable on html_text body' do
      subject.send_type = 'subscription_confirmation'
      # binding.pry
      # expect(subject).to_not be_valid
    end
  end

  describe '#set_default_state' do
    it 'sets default state' do
      expect(subject.state).to be_nil
      subject.run_callbacks :create
      expect(subject).to be_sending
    end
  end
end
