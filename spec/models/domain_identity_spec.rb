require 'rails_helper'

describe DomainIdentity, type: :model do
  let(:domain) { Fabricate.build :domain }

  subject { described_class.new domain }

  before do
    allow(domain).to receive(:save)
    allow(domain).to receive(:destroy)
    expect(domain).to receive(:transaction).and_yield
  end

  describe '#verify!', vcr: { cassette_name: :verify_domain } do
    it 'verifies a new domain identity on SES' do
      subject.verify!

      expect(domain).to be_pending
      expect(domain).to be_dkim_pending
      expect(domain).to be_mail_from_pending
      expect(domain.name).to eq('example.com')
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

      expect(subject.ses).to receive(:set_identity_mail_from_domain)
        .with(identity: domain.name,
              mail_from_domain: "bounce.#{domain.name}",
              behavior_on_mx_failure: 'UseDefaultValue')
        .and_call_original

      subject.verify!
    end
  end

  describe '#update!', vcr: { cassette_name: :identity_attributes } do
    it 'updates domain statuses attributes' do
      expect(subject.ses).to receive(:get_identity_verification_attributes)
        .with(identities: [domain.name])
        .and_call_original

      expect(subject.ses).to receive(:get_identity_mail_from_domain_attributes)
        .with(identities: [domain.name])
        .and_call_original

      expect(subject.ses).to receive(:get_identity_dkim_attributes)
        .with(identities: [domain.name])
        .and_call_original

      subject.update!

      expect(domain).to be_pending
      expect(domain).to be_dkim_pending
      expect(domain).to be_mail_from_pending
    end
  end

  describe '#delete!', vcr: { cassette_name: :delete_identity } do
    it 'removes domain identity permanently' do
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
