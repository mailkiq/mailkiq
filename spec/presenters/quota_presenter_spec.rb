require 'rails_helper'

describe QuotaPresenter do
  subject do
    view = ActionController::Base.new.view_context
    account = Fabricate.build :valid_account
    described_class.new account, view
  end

  before do
    ses = subject.model.quota.instance_variable_get :@ses
    ses.stub_responses :get_send_quota,
                       max_24_hour_send: 50_000.0,
                       max_send_rate: 14.0,
                       sent_last_24_hours: 0.0
  end

  it { is_expected.to delegate_method(:max_24_hour_send).to :send_quota }
  it { is_expected.to delegate_method(:sent_last_24_hours).to :send_quota }
  it { is_expected.to delegate_method(:max_send_rate).to :send_quota }

  describe '#sandbox?' do
    it 'sending quota is equal to 50000' do
      expect(subject.max_24_hour_send).to eq(50_000)
      is_expected.to_not be_sandbox

      expect(subject).to receive(:max_24_hour_send).and_return(200)
      is_expected.to be_sandbox
    end

    it 'moved out from sandbox mode' do
      is_expected.to receive(:max_24_hour_send).and_return(400)
      is_expected.to_not be_sandbox
    end
  end

  describe '#human_send_rate' do
    it 'humanizes send rate' do
      expect(subject.human_send_rate).to eq('14 emails per second')
      expect(subject).to receive(:max_send_rate).and_return(90)
      expect(subject.human_send_rate).to eq('90 emails per second')
    end
  end

  describe '#human_sending_limits' do
    it 'humanizes sending limits' do
      expect(subject).to receive(:sent_last_24_hours).and_return(500_000)
      expect(subject).to receive(:max_24_hour_send).and_return(1_000_000)
      expect(subject.human_sending_limits).to eq('500,000 of 1,000,000')
    end
  end

  describe '#sandbox_badge_tag' do
    it 'makes a span tag with label classes' do
      span = '<span class="label label-default">Sandbox Mode</span>'
      expect(subject.sandbox_badge_tag).to eq(span)
    end
  end

  describe '#send_quota' do
    it 'caches send quota numbers from SES' do
      expect(subject.model.quota).to receive(:cached).with(:send_quota)
        .and_call_original
      expect(subject.send_quota).to be_instance_of OpenStruct
    end
  end

  describe '#send_statistics' do
    it 'caches send statistics metrics' do
      expect(subject.model.quota).to receive(:cached).with(:send_statistics)
        .and_call_original
      expect(subject.send_statistics).to be_instance_of Array
    end
  end
end
