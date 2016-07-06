require 'rails_helper'

RSpec.describe ScopeChain do
  let(:campaign) { Fabricate.build :campaign_with_account, id: 10 }

  subject { described_class.new campaign }

  it do
    expect(ScopeChain::SCOPES).to eq([OpenedScope, TagScope, SentScope])
  end

  describe '#call' do
    it 'chains scopes' do
      relation = double('relation')

      expect(Subscriber).to receive_message_chain(:activated, :where)
        .with(account_id: campaign.account_id)
        .and_return(relation)

      ScopeChain::SCOPES.each do |klass|
        expect_any_instance_of(klass).to receive(:call)
        expect(klass).to receive(:new).with(relation, campaign)
          .and_call_original
      end

      expect(subject.call).to eq(relation)
    end
  end

  describe '#tags' do
    it 'returns segmentation tags' do
      relation = double('relation')

      expect(relation).to receive(:sent).and_return(relation).twice
      expect(relation).to receive(:pluck).with(:id, :name).twice
        .and_return([[5, 'The Truth About Wheat']])

      expect(Campaign).to receive(:where).with(account_id: campaign.account_id)
        .twice.and_return(relation)

      expect(Tag).to receive_message_chain(:where, :pluck).with(:id, :name)
        .and_return([[1, 'Teste']])

      expect(subject.tags)
        .to eq([['Teste', 'tag:1'],
                ['Smart Tags > Opened > The Truth About Wheat', 'opened:5'],
                ['Smart Tags > Sent > The Truth About Wheat', 'sent:5']])
    end
  end
end
