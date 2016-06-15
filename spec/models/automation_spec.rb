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
    it 'requires subscribe_url variable presence' do
      message = t('activerecord.errors.models.automation.subscribe_not_found')

      subject.send_type = 'subscription_confirmation'
      subject.html_text = 'something'
      subject.plain_text = 'something'

      expect(subject).to_not be_valid
      expect(subject.errors[:html_text]).to eq([message])
      expect(subject.errors[:plain_text]).to eq([message])
    end
  end
end
