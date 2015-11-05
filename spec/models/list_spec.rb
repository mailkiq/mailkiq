require 'rails_helper'

describe List, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to_not validate_presence_of :thankyou_subject }
  it { is_expected.to_not validate_presence_of :thankyou_message }
  it { is_expected.to_not validate_presence_of :goodbye_subject }
  it { is_expected.to_not validate_presence_of :goodbye_message }

  context 'with thankyou option enabled' do
    subject { List.new thankyou: true }
    it { is_expected.to validate_presence_of :thankyou_subject }
    it { is_expected.to validate_presence_of :thankyou_message }
  end

  context 'with goodbye option enabled' do
    subject { List.new goodbye: true }
    it { is_expected.to validate_presence_of :goodbye_subject }
    it { is_expected.to validate_presence_of :goodbye_message }
  end

  [:confirm_url, :subscribed_url, :unsubscribed_url].each do |name|
    it { is_expected.to allow_value('http://localhost/confirmation').for name }
    it { is_expected.not_to allow_value('jonh@doe.com').for name }
  end

  it { is_expected.to belong_to :account }
  it { is_expected.to have_many(:custom_fields).dependent :destroy }
  it { is_expected.to have_many(:subscriptions).dependent :delete_all }
  it { is_expected.to have_many(:subscribers).through :subscriptions }
end
