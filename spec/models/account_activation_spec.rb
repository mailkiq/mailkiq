require 'rails_helper'

describe AccountActivation, type: :model do
  let(:account) { Fabricate.build :valid_account }

  subject { described_class.new account }

  describe '#activate' do
    it 'creates a topic and queue to receive SES notifications' do
      topic_arn = 'arn:aws:sns:us-east-1:495707395447:mailkiq'
      queue_url = 'https://sqs.us-east-1.amazonaws.com/495707395447/mailkiq'
      queue = { 'QueueArn' => 'arn:aws:sqs:us-east-1:495707395447:mailkiq' }

      subject.sns.stub_responses(:create_topic, topic_arn: topic_arn)
      subject.sqs.stub_responses(:create_queue, queue_url: queue_url)
      subject.sqs.stub_responses(:get_queue_attributes, attributes: queue)

      expect(subject.sns).to receive(:create_topic).with(name: subject.name)
        .and_call_original

      expect(subject.sqs).to receive(:create_queue)
        .with(
          queue_name: subject.name,
          attributes: {
            'MessageRetentionPeriod' => '1209600',
            'ReceiveMessageWaitTimeSeconds' => '20',
            'VisibilityTimeout' => '10'
          })
        .and_call_original

      expect(subject.sqs).to receive(:get_queue_attributes)
        .with(queue_url: queue_url, attribute_names: ['QueueArn'])
        .and_call_original

      expect(subject.sns).to receive(:subscribe)
        .with(topic_arn: topic_arn,
              endpoint: queue['QueueArn'],
              protocol: :sqs)
        .and_call_original

      expect(account).to receive(:update_columns) do |attributes|
        account.assign_attributes(attributes)
        true
      end

      expect(subject.activate).to be_truthy
    end
  end

  describe '#deactivate' do
    it 'deletes associated topic and queue' do
      expect(subject.sns).to receive(:delete_topic)
        .with(topic_arn: account.aws_topic_arn)
        .and_call_original

      expect(subject.sqs).to receive(:delete_queue)
        .with(queue_url: account.aws_queue_url)
        .and_call_original

      expect(account).to receive(:update_columns)
        .with(aws_topic_arn: nil, aws_queue_url: nil)
        .and_return(true)

      expect(subject.deactivate).to be_truthy
    end
  end
end
