require 'rails_helper'

describe MetricsPresenter do
  let(:campaign) { Fabricate.build :campaign }

  subject do
    view = ActionController::Base.new.view_context
    described_class.new campaign, view
  end

  describe '#delivered' do
    it 'calculates percentage of emails delivered until now' do
      expect(campaign).to receive(:recipients_count).and_return(646_100)
      expect(campaign).to receive_message_chain(:messages_count, :value)
        .and_return(27_137)
      expect(subject.delivered).to eq('4%')
    end
  end
end
