require 'rails_helper'

describe DomainIdentity, type: :model do
  let(:domain) { Fabricate.build :domain }

  subject { described_class.new domain }

  before do
    allow(domain).to receive(:save)
    allow(domain).to receive(:destroy)
    allow(domain).to receive(:transaction).and_yield
  end

  before do
    subject.ses.stub_responses(:get_identity_verification_attributes, {
      verification_attributes: {
        'example.com' => { verification_status: 'Pending' }
      }
    })

    subject.ses.stub_responses(:verify_domain_identity, {
      verification_token: 'G8qYlxUb5fkAus3eY/tp83XPKI0RvChrEfjYl4aEn7s=',
    })

    subject.ses.stub_responses(:verify_domain_dkim, {
      dkim_tokens: [
        'todq4lvd66ptvcfkpgtxo26nx53fkuce',
        'g3jkkqxckrfukxvmyvz43annasly3ccq',
        'vfk7s2mxgg27m7vu5npsh7opco6x66rw'
      ]
    })

    subject.ses.stub_responses(:get_identity_dkim_attributes, {
      dkim_attributes: {
        'example.com' => {
          dkim_enabled: false,
          dkim_verification_status: 'Pending'
        }
      }
    })

    subject.ses.stub_responses(:get_identity_mail_from_domain_attributes, {
      mail_from_domain_attributes: {
        'example.com' => {
          behavior_on_mx_failure: 'UseDefaultValue',
          mail_from_domain: 'bounce.example.com',
          mail_from_domain_status: 'Pending'
        }
      }
    })
  end

  describe '#verify!' do
    it 'verifies a new domain identity on SES' do
      expect(subject.ses).to receive(:verify_domain_identity)
        .with(domain: domain.name)
        .and_call_original

      expect(subject.ses).to receive(:verify_domain_dkim)
        .with(domain: domain.name)
        .and_call_original

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

  describe '#update!' do
    it 'updates domain statuses attributes' do
      expect(subject.ses).to receive(:get_identity_verification_attributes)
        .with(identities: [domain.name])
        .and_call_original

      expect(subject.ses).to receive(:get_identity_dkim_attributes)
        .with(identities: [domain.name])
        .and_call_original

      expect(subject.ses).to receive(:get_identity_mail_from_domain_attributes)
        .with(identities: [domain.name])
        .and_call_original

      subject.update!

      expect(domain).to be_pending
      expect(domain).to be_dkim_pending
      expect(domain).to be_mail_from_pending
    end
  end

  describe '#delete!' do
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
