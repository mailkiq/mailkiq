require 'rails_helper'

describe DomainWorker, type: :worker do
  it { is_expected.to save_backtrace }
  it { is_expected.to be_processed_in :platform }

  it 'update verficaition attributes', vcr: { cassette_name: :get_identity_verification_attributes } do
    account = Fabricate.build :valid_account
    domain = Fabricate.build :domain

    expect(account).to receive(:domains).and_return([domain])
    expect(Account).to receive(:find).with(1).and_return(account)
    expect(domain).to receive(:update_columns).with(
      status: Domain.statuses[:success],
      verification_token: 'oPld11CtXSBGVTVgv6DFtRe2EdmM5I6R6OfADMQ++kQ='
    )

    subject.perform(1)
  end
end
