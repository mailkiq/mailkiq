require 'rails_helper'

describe AccountTopic, type: :model do
  let(:account) { Fabricate.build :valid_account }

  subject { described_class.new account }

  describe '#up', vcr: { cassette_name: :create_topic } do
    it 'creates a topic which SES notifications can be published' do
      default_url_options = ActionMailer::Base.default_url_options.dup
      ActionMailer::Base.default_url_options[:host] = 'mailkiq.com'

      expect(account).to receive(:update_column) do |name, value|
        account.assign_attributes name => value
      end

      subject.up
      expect(account.aws_topic_arn).not_to be_nil

      ActionMailer::Base.default_url_options = default_url_options
    end
  end

  describe '#down', vcr: { cassette_name: :delete_topic } do
    it 'deletes a topic and all its subscriptions' do
      account.aws_topic_arn = 'arn:aws:sns:us-east-1:495707395447:mailkiq'
      expect(subject.down).to be_successful
    end
  end
end
