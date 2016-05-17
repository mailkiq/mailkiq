require 'rails_helper'

describe Email, type: :model do
  let(:campaign) { Fabricate.build :campaign_with_account, id: rand(100) }
  let(:subscriber) { Fabricate.build :subscriber, id: rand(100) }
  let(:ses) { subject.instance_variable_get :@ses }
  let(:uuid) { SecureRandom.uuid }

  subject { described_class.new campaign.id, subscriber.id }

  it { is_expected.to respond_to :token }

  before do
    allow(Campaign).to receive(:find).with(campaign.id).and_return(campaign)
    allow(Subscriber).to receive(:find).with(subscriber.id)
      .and_return(subscriber)
    allow(Message).to receive(:create!)
    allow_any_instance_of(EmailProcessor).to receive(:transform!)
  end

  describe '#subscription_token' do
    it 'generates an unsubscription token' do
      expect(subject.subscription_token).to eq Token.encode(subscriber.id)
    end
  end

  describe '#deliver!' do
    it 'delivers campaign to subscriber' do
      mail = double 'mail'

      expect(mail).to receive(:mime_version=).with('1.0')
      expect(mail).to receive(:charset=).with('UTF-8')
      expect(mail).to receive(:to=).with(subscriber.email)
      expect(mail).to receive(:from=).with(campaign.from)
      expect(mail).to receive(:subject=).with(campaign.subject)
      expect(mail).to receive(:destinations).and_return([subscriber.email])
      expect(mail).to receive(:text_part=).with(campaign.plain_text)
      expect(mail).to receive(:html_part=).with(campaign.html_text)

      expect(Mail::Message).to receive(:new).and_return(mail)
      expect(ses).to receive(:send_raw_email).and_call_original

      ses.stub_responses :send_raw_email, message_id: uuid

      subject.deliver!
    end

    it 'creates a message record on the database' do
      expect(Message).to receive(:create!)
        .with hash_including(uuid: uuid,
                             token: subject.token,
                             campaign_id: campaign.id,
                             subscriber_id: subscriber.id)

      ses.stub_responses :send_raw_email, message_id: uuid

      subject.deliver!
    end
  end
end
