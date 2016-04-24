require 'rails_helper'

describe CampaignQueue, type: :model do
  let(:campaign) { Fabricate.build :campaign, id: 1 }

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

  describe '#remove' do
    it 'completely deletes the queue' do
      expect(Resque).to receive(:remove_queue).with(subject.name)
      subject.remove
    end
  end

  describe '.remove_dead_queues' do
    it 'removes dead queues' do
      queues = %w(campaign-1 blah)

      expect(Resque).to receive(:queues).and_return(queues)
      expect(Resque).to receive(:remove_queue).with(queues.first)
      expect(Resque).not_to receive(:remove_queue).with(queues.last)
      expect(Resque).to receive(:size).with(queues.first).and_return(0)

      described_class.remove_dead_queues
    end
  end
end
