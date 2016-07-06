require 'rails_helper'

RSpec.describe NotificationManager do
  let(:account) { Fabricate.build :valid_account }
  let(:sns) { subject.instance_variable_get :@message }
  let(:message) { Message.new campaign_id: 1 }
  let(:notification) { Notification.new message: message }

  subject { described_class.new fixture_file('bounce.json'), account.id }

  describe '#create!' do
    it 'creates a new bounce notification' do
      expect(Subscriber).to receive(:update_state)
        .with(state: sns.state, email: sns.emails, account_id: account.id)

      expect(message).to receive(:update_column)
        .with(:state, Message.states[sns.message_type.downcase])

      expect(message).to receive_message_chain(:notifications, :create!)
        .with(data: sns.data.as_json) do |attrs|
          notification.assign_attributes(attrs)
          notification
        end

      expect(Message).to receive(:find_by!).with(uuid: sns.mail_id)
        .and_return(message)

      expect(Campaign).to receive(:increment_counter).with('bounces_count', 1)

      subject.create!
    end
  end
end
