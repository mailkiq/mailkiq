require 'rails_helper'

describe AccountTopic, type: :model do
  let(:account) { Fabricate.build :valid_account }

  subject { described_class.new account }

  describe '#up' do
    it 'creates a topic which SES notifications can be published' do
      topic_arn = 'arn:aws:sns:us-east-1:495707395447:mailkiq'

      subject.client.stub_responses(:create_topic, topic_arn: topic_arn)

      expect(subject.client).to receive(:create_topic)
        .with(name: subject.name)
        .and_call_original

      expect(subject.client).to receive(:subscribe)
        .with(hash_including(topic_arn: topic_arn, protocol: :http))
        .and_call_original

      expect(account).to receive(:update_column) do |name, value|
        account.assign_attributes name => value
        true
      end

      expect(subject.up).to be_truthy
    end
  end

  describe '#down' do
    it 'deletes a topic and all its subscriptions' do
      expect(subject.client).to receive(:delete_topic)
        .with(topic_arn: account.aws_topic_arn)
        .and_call_original

      expect(subject.down).to be_successful
    end
  end
end
