require 'rails_helper'

describe Segment, type: :model do
  let(:account) { Fabricate.build :account, id: 10 }

  subject { Fabricate.build :segment, account: account }

  it { is_expected.to respond_to :account }
  it { is_expected.to respond_to :tagged_with }
  it { is_expected.to respond_to :not_tagged_with }
  it { expect(described_class.ancestors).to include ActiveModel::Model }
  it { expect(Segment::QUERIES).to eq([OpenedQuery, TagQuery]) }

  describe '#initialize' do
    it 'coerse string to array' do
      subject.tagged_with = 'blah'
      subject.not_tagged_with = 'blah b'
      expect(subject.tagged_with).to eq(['blah'])
      expect(subject.not_tagged_with).to eq(['blah b'])
    end
  end

  describe '#jobs' do
    it 'args for bulk processing' do
      expect(subject).to receive_message_chain(:chain_queries, :pluck)
        .and_return([2, 3, 4])
      expect(subject.jobs(campaign_id: 1)).to eq([[1, 2], [1, 3], [1, 4]])
    end
  end

  describe '#chain_queries' do
    it 'call available query objects (aka smart tags and static tags)' do
      relation = double
      expect(relation).to receive(:actived).and_return(relation)
      expect(Subscriber).to receive(:where).with(account_id: 10)
        .and_return(relation)

      Segment::QUERIES.each do |klass|
        expect_any_instance_of(klass).to receive(:call)
        expect(klass).to receive(:new)
          .with(relation, subject.tagged_with, subject.not_tagged_with)
          .and_call_original
      end

      expect(subject.send(:chain_queries)).to eq(relation)
    end
  end
end
