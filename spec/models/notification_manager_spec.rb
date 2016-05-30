require 'rails_helper'

describe NotificationManager do
  let(:account) { Fabricate.build :valid_account }
  let(:sns) { subject.instance_variable_get :@message }

  subject { described_class.new fixture_file('bounce.json'), account.id }

  describe '#create!' do
    before do
      message = Message.new campaign_id: 1
      notification = Notification.new message: message

      expect(Subscriber).to receive(:update_state)
        .with(state: sns.state, email: sns.emails, account_id: account.id)

      expect(message).to receive(:update_column)
        .with(:state, sns.message_type.downcase)

      expect(message).to receive_message_chain(:notifications, :create!)
        .with(data: sns.data.as_json) do |attrs|
          notification.assign_attributes(attrs)
          notification
        end

      expect(Message).to receive(:find_by!).with(uuid: sns.mail_id)
        .and_return(message)
    end

    it 'creates a new bounce notification' do
      expect(Campaign).to receive(:increment_counter).with('bounces_count', 1)

      subject.create!
    end
  end
end
