require 'rails_helper'

describe CampaignQueue, type: :model do
  let(:campaign) { Fabricate.build(:campaign, id: 1) }

  subject { described_class.new campaign }

  describe '#name' do
    it 'generates queue name' do
      expect(subject.name).to eq('campaign-1')
    end
  end

  describe '#push_bulk' do
    it 'pushes a large number of jobs to the queue' do
      queue_name = "queue:#{subject.name}"

      subject.push_bulk [[1, 1], [1, 2]]

      expect(Resque.redis.exists(queue_name)).to be_truthy
      expect(Resque.redis.sismember('queues', subject.name)).to be_truthy
      expect(Resque.redis.llen(queue_name)).to eq(2)
    end
  end

  describe '#clear' do
    it 'unwatches queue and remove all pending jobs' do
      expect(Resque).to receive(:remove_queue).with(subject.name)
      expect(Resque).to receive_message_chain(:redis, :del)
        .with("queue:#{subject.name}")

      subject.clear
    end
  end
end
