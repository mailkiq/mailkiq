require 'rails_helper'

RSpec.describe Delivery, type: :model do
  let(:campaign) { Fabricate.build :campaign_with_account, id: 10 }

  subject { described_class.new campaign }

  before do
    allow_any_instance_of(DomainValidator).to receive(:validate_each)
    allow_any_instance_of(ScopeChain).to receive(:count).and_return(0)
  end

  describe '#enqueue!' do
    it 'enqueues delivery job' do
      params = { tagged_with: %w(tag:1) }

      expect_any_instance_of(Quota).to receive(:exceed?).and_return(false)
      expect_any_instance_of(Quota).to receive(:use!).with(subject.count)

      expect(campaign).to receive(:assign_attributes).with(params)
        .and_call_original
      expect(campaign).to receive(:enqueue!).and_yield
      expect(campaign).to receive(:recipients_count=).with(subject.count)
        .and_call_original
      expect(campaign).to receive(:save!)
      expect(DeliveryJob).to receive(:enqueue).with(campaign.id)

      subject.enqueue!(params)
    end

    it 'raises exception when invalid' do
      expect_any_instance_of(Quota).to receive(:exceed?).and_return(true)
      expect(campaign).to receive(:enqueue!).and_yield
      expect { subject.enqueue! }
        .to raise_exception(ActiveRecord::RecordInvalid)
    end
  end

  describe '#deliver!' do
    it 'inserts jobs to the queue table' do
      expect(campaign).to receive(:deliver!).and_yield

      expect_any_instance_of(ScopeChain).to receive(:to_sql)
      expect(Query).to receive(:execute)
        .with(:queue_jobs, with: anything, campaign_id: campaign.id)
        .and_return(true)
      expect(FinishJob).to receive(:enqueue).with(campaign.id)

      subject.deliver!
    end
  end

  describe '#delete' do
    it 'deletes pending jobs' do
      statement = <<-SQL.squish!
        DELETE FROM que_jobs WHERE job_class = 'CampaignJob'
        AND args::text ILIKE '[10,%'
      SQL

      expect(ActiveRecord::Base.connection).to receive(:execute)
        .with(statement, 'Delete Campaign Jobs')

      subject.delete
    end
  end
end
