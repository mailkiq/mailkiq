require 'rails_helper'

describe QuotaPresenter, vcr: { cassette_name: :get_send_quota } do
  subject do
    account = Fabricate.build(:valid_account)
    view = ActionController::Base.new.view_context
    described_class.new account, view
  end

  it { is_expected.to respond_to :t }
  it { is_expected.to respond_to :content_tag }
  it { is_expected.to respond_to :view_context }
  it { is_expected.to respond_to :account }

  describe '#sandbox?' do
    it 'sending quota is equal to 50000' do
      expect(subject.max_hour_send).to eq(50_000)
      is_expected.to_not be_sandbox

      expect(subject).to receive(:max_hour_send).and_return(200)
      is_expected.to be_sandbox
    end

    it 'moved out from sandbox mode' do
      is_expected.to receive(:max_hour_send).and_return(400)
      is_expected.to_not be_sandbox
    end
  end

  describe '#max_send_rate' do
    it 'coerse MaxSendRate attribute to a number' do
      expect(subject.send_quota['MaxSendRate']).to eq('14.0')
      expect(subject.max_send_rate).to eq(14)
    end
  end

  describe '#max_hour_send' do
    it 'coerse Max24HourSend attribute to a number' do
      expect(subject.send_quota['Max24HourSend']).to eq('50000.0')
      expect(subject.max_hour_send).to eq(50_000)
    end
  end

  describe '#sent_last_hours' do
    it 'coerse SentLast24Hours attribute to a number' do
      expect(subject.send_quota['SentLast24Hours']).to eq('0.0')
      expect(subject.sent_last_hours).to be_zero
    end
  end

  describe '#human_send_rate' do
    it 'friendly send rate number ' do
      expect(subject.human_send_rate).to eq('14 emails per second')
      expect(subject).to receive(:max_send_rate).and_return(90)
      expect(subject.human_send_rate).to eq('90 emails per second')
    end
  end

  describe '#human_sending_limits' do
    it 'friendly sending limits number' do
      expect(subject).to receive(:sent_last_hours).and_return(500_000)
      expect(subject).to receive(:max_hour_send).and_return(1_000_000)
      expect(subject.human_sending_limits).to eq('500,000 of 1,000,000')
    end
  end

  describe '#sandbox_badge_tag' do
    it 'make a span tag with label classes' do
      span = '<span class="label label-default">Sandbox Mode</span>'
      expect(subject.sandbox_badge_tag).to eq(span)
    end
  end
end
