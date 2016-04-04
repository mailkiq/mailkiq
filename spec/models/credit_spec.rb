require 'rails_helper'

describe Credit, type: :model do
  let(:account) { Fabricate.build :account }

  subject { described_class.new account }

  before do
    allow(account).to receive_message_chain(:used_credits, :value).and_return(5)
    allow(account).to receive(:plan_credits).at_least(:once).and_return(10)
  end

  describe '#remaining' do
    it 'returns remaining credits' do
      expect(subject.remaining).to eq(5)
    end
  end

  describe '#exceed?' do
    it 'checks if account has enough credits with the given value' do
      expect(subject).to be_exceed(6)
      expect(subject).not_to be_exceed(5)
    end
  end
end
