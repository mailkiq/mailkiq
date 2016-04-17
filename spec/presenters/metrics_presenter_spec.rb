require 'rails_helper'

describe MetricsPresenter do
  let(:campaign) { Fabricate.build :campaign }

  subject do
    view = ActionController::Base.new.view_context
    described_class.new campaign, view
  end

  describe '#delivered' do
    it 'calculates percentage of emails delivered until now' do
      is_expected.to receive(:percentage_for).with(:messages_count)
        .and_call_original

      expect(campaign).to receive(:recipients_count).and_return(646_100)
      expect(campaign).to receive_message_chain(:messages_count, :value)
        .and_return(27_137)
      expect(subject.delivered).to eq('4%')
    end
  end

  describe '#bounces' do
    it 'calculates percentage of bounced emails' do
      is_expected.to receive(:percentage_for).with(:bounces_count)
      subject.bounces
    end
  end

  describe '#complaints' do
    it 'calculates percentage of complained emails' do
      is_expected.to receive(:percentage_for).with(:complaints_count)
      subject.complaints
    end
  end

  describe '#unsent' do
    it 'calculates percentage of unsent emails' do
      is_expected.to receive(:percentage_for).with(:unsent_count)
      subject.unsent
    end
  end
end
