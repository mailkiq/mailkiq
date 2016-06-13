require 'rails_helper'

describe CampaignMailer do
  let(:campaign) { Fabricate.build :automation_with_account, id: rand(100) }
  let(:subscriber) { Fabricate.build :subscriber, id: rand(100) }
  let(:ses) { subject.instance_variable_get :@ses }
  let(:uuid) { SecureRandom.uuid }

  subject { described_class.new campaign.id, subscriber.id }

  it { is_expected.to respond_to :token }

  before do
    allow(Campaign).to receive_message_chain(:unscoped, :find)
      .with(campaign.id)
      .and_return(campaign)
    allow(Subscriber).to receive(:find).with(subscriber.id)
      .and_return(subscriber)
    allow(Message).to receive(:create!)
    allow_any_instance_of(MailerProcessor).to receive(:transform!)
  end

  describe '#deliver!' do
    before do
      ses.stub_responses :send_raw_email, message_id: uuid
      expect(ses).to receive(:send_raw_email).and_call_original
      expect(campaign).to receive(:increment!).with(:recipients_count)
    end

    it 'delivers campaign' do
      mail = subject.deliver!

      expect(mail.subject).to eq(campaign.subject)
      expect(mail.from).to eq([campaign.from_email])
      expect(mail.to).to eq([subscriber.email])
      expect(mail.charset).to eq('UTF-8')
      expect(mail.text_part.body).to eq(campaign.plain_text)
      expect(mail.text_part.content_type).to eq('text/plain; charset=UTF-8')
      expect(mail.html_part.body).to eq(campaign.html_text)
      expect(mail.html_part.content_type).to eq('text/html; charset=UTF-8')
    end

    it 'inserts a new message on the database' do
      travel 1.day

      expect(Message).to receive(:create!).with(
        uuid: uuid,
        token: subject.token,
        campaign_id: campaign.id,
        subscriber_id: subscriber.id,
        sent_at: Time.now)

      subject.deliver!

      travel_back
    end
  end

  describe '#utm_params' do
    it 'returns Google Analytics parameters' do
      expect(subject.utm_params).to eq(
        utm_campaign: 'confirmation',
        utm_medium: :email,
        utm_source: :mailkiq)
    end
  end

  describe '#subscription_token' do
    it 'generates an unsubscription token' do
      expect(subject.subscription_token).to eq Token.encode(subscriber.id)
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
end
