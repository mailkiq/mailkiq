require 'rails_helper'

RSpec.describe AccountActivation, type: :model do
  let(:account) { Fabricate.build :valid_account, id: 1 }

  subject { described_class.new account }

  let(:sns) { subject.instance_variable_get :@sns }
  let(:sqs) { subject.instance_variable_get :@sqs }

  describe '#name' do
    it 'generantes unique name for queue and topic' do
      expect(account).to_not be_tied_to_mailkiq
      expect(subject.name).to eq('mailkiq')

      expect(account).to receive(:tied_to_mailkiq?).and_return(true)
      expect(subject.name).to eq('mailkiq-1')
    end
  end

  describe '#activate' do
    it 'creates a topic and queue to receive SES notifications' do
      queue = Aws.config.dig \
        :sqs, :stub_responses, :get_queue_attributes, :attributes
      topic_arn = Aws.config.dig \
        :sns, :stub_responses, :create_topic, :topic_arn
      queue_url = Aws.config.dig \
        :sqs, :stub_responses, :create_queue, :queue_url

      queue_arn = queue['QueueArn']
      policy = ERB.new(IO.read('lib/aws/sqs/policy.json.erb')).result(binding)

      expect(sns).to receive(:create_topic).with(name: subject.name)
        .and_call_original

      expect(sqs).to receive(:create_queue)
        .with(queue_name: subject.name,
              attributes: {
                'MessageRetentionPeriod' => '1209600',
                'ReceiveMessageWaitTimeSeconds' => '20',
                'VisibilityTimeout' => '10'
              }).and_call_original

      expect(sqs).to receive(:get_queue_attributes)
        .with(queue_url: queue_url, attribute_names: ['QueueArn'])
        .and_call_original

      expect(sqs).to receive(:set_queue_attributes)
        .with(queue_url: queue_url, attributes: { 'Policy' => policy })
        .and_call_original

      expect(sns).to receive(:subscribe)
        .with(topic_arn: topic_arn,
              endpoint: queue_arn,
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
      expect(sns).to receive(:delete_topic)
        .with(topic_arn: account.aws_topic_arn)
        .and_call_original

      expect(sqs).to receive(:delete_queue)
        .with(queue_url: account.aws_queue_url)
        .and_call_original

      expect(account).to receive(:update_columns)
        .with(aws_topic_arn: nil, aws_queue_url: nil)
        .and_return(true)

      expect(subject.deactivate).to be_truthy
    end
  end
end
