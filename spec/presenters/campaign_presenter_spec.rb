require 'rails_helper'

describe CampaignPresenter do
  let(:campaign) { Fabricate.build :campaign_with_account }

  subject do
    view = ActionController::Base.new.view_context
    described_class.new campaign, view
  end

  it { is_expected.to delegate_method(:name).to(:model) }
  it { is_expected.to delegate_method(:recipients_count).to(:model) }
  it { is_expected.to delegate_method(:to_percentage).to(:model) }
  it { is_expected.to delegate_method(:bounces_count).to(:model) }
  it { is_expected.to delegate_method(:unsent_count).to(:model) }
  it { is_expected.to delegate_method(:messages_count).to(:model) }
  it { is_expected.to delegate_method(:complaints_count).to(:model) }

  describe '#delivered' do
    it 'calculates percentage of emails delivered until now' do
      is_expected.to receive(:to_percentage).with(:messages_count)
        .and_call_original

      expect(campaign).to receive(:recipients_count).and_return(646_100)
      expect(campaign).to receive(:messages_count).and_return(27_137)

      expect(subject.delivered).to eq('4%')
    end
  end

  describe '#bounces' do
    it 'calculates percentage of bounced emails' do
      is_expected.to receive(:to_percentage).with(:bounces_count)
        .and_return(0.85043)

      expect(subject.bounces).to eq('0.85%')
    end
  end

  describe '#complaints' do
    it 'calculates percentage of complained emails' do
      is_expected.to receive(:to_percentage).with(:complaints_count)
        .and_return(12.597)

      expect(subject.complaints).to eq('13%')
    end
  end

  describe '#unsent' do
    it 'calculates percentage of unsent emails' do
      is_expected.to receive(:to_percentage).with(:unsent_count)
        .and_return(10.0)

      expect(subject.unsent).to eq('10%')
    end
  end

  describe '#long_sent_at' do
    it 'returns friendly time description' do
      expect(subject.long_sent_at)
        .to eq('<small>Sent on May 29, 2016 14:13 to 600,000 subscribers.</small>')
    end
  end

  describe '#progress' do
    it 'generates markup for progress bar segments' do
      allow(campaign).to receive(:recipients_count).and_return(646_100)

      expect(campaign).to receive(:deliveries_count).and_return(200_000)
      expect(campaign).to receive(:bounces_count).and_return(10)
      expect(campaign).to receive(:complaints_count).and_return(5_000)
      expect(campaign).to receive(:unsent_count).and_return(446_100)

      html = Nokogiri::HTML.fragment subject.progress

      expect(html.at_css('.deliveries')[:style]).to end_with '31%'
      expect(html.at_css('.bounces')[:style]).to end_with '0%'
      expect(html.at_css('.complaints')[:style]).to end_with '1%'
      expect(html.at_css('.unsent')[:style]).to end_with '69%'
    end
  end

  describe '#meter_tag' do
    it 'generates markup for a meter component' do
      html = Nokogiri::HTML.fragment subject.meter_tag(:unique_opens_count)

      expect(html.at_css('.meter').children).to_not be_empty
      expect(html.at_css('.meter span')[:style]).to eq('width: 0.0%')
    end
  end
end
