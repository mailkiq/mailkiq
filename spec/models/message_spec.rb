require 'rails_helper'

describe Message, type: :model do
  it { is_expected.to belong_to :subscriber }
  it { is_expected.to belong_to(:campaign).counter_cache true }
  it { is_expected.to have_many :notifications }

  describe '#unopened?' do
    it 'verifies presence of opened_at column' do
      subject.opened_at = nil
      expect(subject).to be_unopened

      subject.opened_at = Time.zone.now
      expect(subject).not_to be_unopened
    end
  end

  describe '#unclicked?' do
    it 'verifies presence of clicked_at column' do
      subject.clicked_at = nil
      expect(subject).to be_unclicked

      subject.clicked_at = Time.zone.now
      expect(subject).not_to be_unclicked
    end
  end

  describe '#see!' do
    it 'sets some attributes with the given request object' do
      request = ActionController::TestRequest.new

      expect(subject).to receive(:save!)

      subject.see! request

      expect(subject.opened_at).not_to be_nil
      expect(subject.referer).to eq(request.referer)
      expect(subject.ip_address).to eq(request.remote_ip)
      expect(subject.user_agent).to eq(request.user_agent)
    end
  end

  describe '#click!' do
    it 'sets some attributes with the given request object' do
      request = ActionController::TestRequest.new

      expect(subject).to receive(:save!)

      subject.click! request

      expect(subject.opened_at).not_to be_nil
      expect(subject.clicked_at).to eq(subject.opened_at)
      expect(subject.referer).to eq(request.referer)
      expect(subject.ip_address).to eq(request.remote_ip)
      expect(subject.user_agent).to eq(request.user_agent)
    end
  end
end
