require 'rails_helper'

describe CampaignQueue, type: :model do
  let(:campaign) { Fabricate.build(:campaign, id: 1) }

  subject { described_class.new campaign }

  describe '#name' do
    it 'generates an queue name' do
      expect(subject.name).to eq('campaign-1')
    end
  end

  describe '#clear' do
    it 'removes queue and pending jobs' do
      expect_any_instance_of(Sidekiq::Queue).to receive(:clear)
      subject.clear
    end
  end

  describe '#push_bulk' do
    it 'pushes a large number of jobs to the queue' do
      jobs = [[1, 1], [1, 2]]

      expect(Sidekiq::Client).to receive(:push_bulk)
        .with('queue' => subject.name,
              'class' => CampaignWorker,
              'args'  => jobs)
        .and_call_original

      subject.push_bulk(jobs)
    end
  end
end
