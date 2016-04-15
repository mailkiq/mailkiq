require 'rails_helper'

describe ProgressPresenter do
  let(:campaign) { Fabricate.build :campaign }

  subject do
    view = ActionController::Base.new.view_context
    described_class.new campaign, view
  end

  describe '#render' do
    it 'generates HTML markup for progress bar segments' do
      expect(campaign).to receive(:recipients_count)
        .at_least(:once)
        .and_return(646_100)

      expect(campaign).to receive(:messages_count).and_return(200_000)
      expect(campaign).to receive(:bounces_count).and_return(10)
      expect(campaign).to receive(:complaints_count).and_return(5_000)
      expect(campaign).to receive(:rejects_count).and_return(0)
      expect(campaign).to receive(:unsent_count).and_return(446_100)

      html = Nokogiri::HTML(subject.render)

      expect(html.at_css('.messages')[:style]).to end_with '31%'
      expect(html.at_css('.bounces')[:style]).to end_with '0%'
      expect(html.at_css('.complaints')[:style]).to end_with '1%'
      expect(html.at_css('.rejects')[:style]).to end_with '0%'
      expect(html.at_css('.unsent')[:style]).to end_with '69%'
    end
  end
end
