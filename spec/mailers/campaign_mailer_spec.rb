require 'rails_helper'

describe CampaignMailer do
  let(:automation) { Fabricate.create :automation_with_account }
  let(:subscriber) { Fabricate.create :subscriber, account: automation.account }
  let(:ses) { subject.instance_variable_get :@ses }
  let(:uuid) { SecureRandom.uuid }

  subject { described_class.new automation.id, subscriber.id }

  before do
    allow_any_instance_of(DomainValidator).to receive(:validate_each)
    ses.stub_responses :send_raw_email, message_id: uuid
  end

  describe '#deliver!' do
    it 'delivers automation to the subscriber' do
      expect(ses).to receive(:send_raw_email).and_call_original

      mail = subject.deliver!
      mail_subject = automation.subject.render!(subscriber.interpolations)

      expect(mail.subject).to eq(mail_subject)
      expect(mail.from).to eq([automation.from_email])
      expect(mail.to).to eq([subscriber.email])
      expect(mail.charset).to eq('UTF-8')
      expect(mail.text_part.body.raw_source).to match(/Obrigado.*localhost/m)
      expect(mail.text_part.content_type).to eq('text/plain; charset=UTF-8')
      expect(mail.html_part.body.raw_source).to match(/Obrigado.*localhost/m)
      expect(mail.html_part.content_type).to eq('text/html; charset=UTF-8')

      message = Message.first

      expect(message.campaign).to be_nil
      expect(message.automation).to eq(automation)
      expect(message.subscriber).to eq(subscriber)
      expect(message.uuid).to eq(uuid)
      expect(message.sent_at).to_not be_nil

      expect(automation.reload.recipients_count).to eq(1)
    end
  end
end
