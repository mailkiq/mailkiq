require 'rails_helper'

describe CampaignWorker, type: :worker do
  it { is_expected.to save_backtrace }
  it { is_expected.to be_retryable 3 }

  it 'delivers campaign to subscriber' do
    expect(CampaignMailer).to receive_message_chain(:campaign, :deliver_now)
    subject.perform(1, 1)
  end

  it 'catch error and fixes email address' do
    subscriber = Fabricate.build(:subscriber_with_dot)

    expect(Subscriber).to receive(:find).with(1).and_return(subscriber)
    expect(CampaignMailer).to receive_message_chain(:campaign, :deliver_now)
      .and_raise(Fog::AWS::SES::InvalidParameterError, 'Domain starts with dot')
    expect(subscriber).to receive(:update_column)
      .with(:email, 'franrodrigues1962@gmail.com')

    # We need this to make sure Sidekiq will retry the job.
    expect { subject.perform(1, 1) }
      .to raise_error Fog::AWS::SES::InvalidParameterError
  end
end
