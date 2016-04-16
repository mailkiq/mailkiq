require 'rails_helper'

describe Aws::SNS::Message do
  let(:bounce) { described_class.load fixture(:bounce) }
  let(:complaint) { described_class.load fixture(:complaint) }
  let(:delivery) { described_class.load fixture(:delivery) }
  let(:subscription) do
    described_class.load fixture(:subscription_confirmation)
  end

  describe '.load' do
    it 'parses JSON string and instantiate message' do
      expect(described_class).to receive(:new)
        .with(hash_including(Type: 'SubscriptionConfirmation'))
        .and_call_original

      subscription
    end
  end

  describe '#subscription_confirmation?' do
    it 'compares notification type' do
      expect(subscription.attributes[:Type]).to eq('SubscriptionConfirmation')
      expect(subscription).to be_subscription_confirmation
    end
  end

  describe '#topic_arn' do
    it 'returns topic ARN attribute' do
      expect(subscription.topic_arn).to eq(subscription.attributes[:TopicArn])
    end
  end

  describe '#token' do
    it 'returns token attribute' do
      expect(subscription.token).to eq(subscription.attributes[:Token])
    end
  end

  describe '#mail_id' do
    it 'returns unique ID for the original message' do
      expect(subscription.mail_id).to be_nil
      expect(bounce.mail_id).to_not be_nil
      expect(bounce.mail_id)
        .to eq(bounce.attributes[:Message][:mail][:messageId])
    end
  end

  describe '#message_type' do
    it 'returns type of notification' do
      expect(subscription.message_type).to be_nil
      expect(bounce.message_type).to eq('Bounce')
      expect(complaint.message_type).to eq('Complaint')
      expect(delivery.message_type).to eq('Delivery')
    end
  end

  describe '#state' do
    it 'returns symbolized value of the notification type' do
      expect(subscription.state).to be_nil
      expect(bounce.state).to eq(:bounced)
      expect(complaint.state).to eq(:complained)
      expect(delivery.state).to eq(:active)
    end
  end

  describe '#emails' do
    it 'returns list of email addresses' do
      expect(bounce.emails).to eq(['paku@uai.com.br'])
      expect(complaint.emails).to eq(['romecosta@yahoo.com'])
      expect(delivery.emails).to eq(['success@simulator.amazonses.com'])
    end
  end

  describe '#data' do
    it 'returns notification contents for Amazon SES' do
      expect(bounce).to receive(:search)
        .with('Message.bounce || Message.complaint || Message.delivery')
        .and_call_original

      expect(bounce.data).to eq(bounce.attributes[:Message][:bounce])
    end
  end

  describe '#ses?' do
    it 'verifies data presence' do
      expect(subscription).not_to be_ses
      expect(bounce).to be_ses
      expect(complaint).to be_ses
      expect(delivery).to be_ses
    end
  end
end
