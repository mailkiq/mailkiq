require 'rails_helper'

describe NotificationManager do
  let(:bounce_json) { File.read('spec/fixtures/bounce.json') }
  let(:subscription_json) do
    File.read('spec/fixtures/subscription_confirmation.json')
  end

  let(:account) { Fabricate.build :valid_account }
  let(:message) { Message.new campaign_id: 1 }
  let(:notification) { Notification.new message: message }

  describe '#confirm', vcr: { cassette_name: :confirm_subscription } do
    it 'confirms intent to receive messages' do
      response = described_class.new(account, subscription_json).confirm
      expect(response).to be_successful
    end
  end

  describe '#create!' do
    subject { described_class.new account, bounce_json }

    before do
      relation = double

      expect(relation).to receive(:where).with(email: subject.message.emails)
        .and_return(relation)

      expect(relation).to receive(:update_all)
        .with(state: Subscriber.states.fetch(subject.message.state))

      expect(account).to receive(:subscribers).and_return(relation)

      expect(message).to receive_message_chain(:notifications, :create!)
        .with(subject.attributes) do |attrs|
          notification.assign_attributes(attrs)
          notification
        end

      expect(Message).to receive(:find_by!).with(uuid: subject.message.mail_id)
        .and_return(message)
    end

    it 'creates a new bounce notification' do
      expect(Campaign).to receive(:increment_counter).with('bounces_count', 1)

      subject.create!
    end

    it 'creates a new delivery notification' do
      expect(Campaign).not_to receive(:increment_counter)
      expect_any_instance_of(Notification).to receive(:delivery?)
        .and_return(true)

      subject.create!
    end
  end

  describe '#attributes' do
    it 'slices message type and data object attributes' do
      manager = described_class.new(account, bounce_json)
      attributes = manager.attributes
      expect(attributes[:type]).to eq(manager.message.message_type.downcase)
      expect(attributes[:data]).to eq(manager.message.data.as_json)
    end
  end
end
