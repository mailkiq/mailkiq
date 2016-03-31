require 'rails_helper'

describe DomainIdentity, type: :model do
  let(:domain) { Fabricate.build :domain }

  subject { described_class.new domain }

  describe '#verify!', vcr: { cassette_name: :verify_domain } do
    before do
      expect(domain).to receive(:save)
      expect(domain).to receive(:transaction).and_yield
    end

    it 'verifies a new domain identity on SES' do
      subject.verify!

      expect(domain.name).to eq('example.com')
      expect(domain.status).to eq('pending')
      expect(domain.verification_token.size).to eq(44)
      expect(domain.dkim_tokens.size).to eq(3)
    end

    it 'sets identity notification topics' do
      expect(subject.ses).to receive(:set_identity_notification_topic)
        .with(notification_topic_options_for(:Bounce))
        .and_call_original

      expect(subject.ses).to receive(:set_identity_notification_topic)
        .with(notification_topic_options_for(:Complaint))
        .and_call_original

      expect(subject.ses).to receive(:set_identity_notification_topic)
        .with(notification_topic_options_for(:Delivery))
        .and_call_original

      expect(subject.ses).to receive(:set_identity_feedback_forwarding_enabled)
        .with(identity: domain.name, forwarding_enabled: false)
        .and_call_original

      subject.verify!
    end
  end

  describe '#delete!', vcr: { cassette_name: :delete_identity } do
    it 'removes domain identity permanently' do
      expect(domain).to receive(:transaction).and_yield
      expect(domain).to receive(:destroy)

      expect(subject.ses).to receive(:delete_identity)
        .with(identity: domain.name)
        .and_call_original

      subject.delete!
    end
  end

  def notification_topic_options_for(type)
    {
      identity: domain.name,
      sns_topic: domain.account_aws_topic_arn,
      notification_type: type
    }
  end
end
