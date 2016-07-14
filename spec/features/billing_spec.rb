require 'rails_helper'

RSpec.feature 'Billing' do
  let(:account) { Fabricate.create :paid_account }

  before do
    FakeBilling.stub!
  end

  scenario 'suspends subscription' do
    expect_any_instance_of(Iugu::Subscription).to receive(:suspend)
    sign_in account
    visit edit_account_registration_path
    click_link 'Suspender'

    expect(page.status_code).to eq 200
  end

  scenario 'activates subscription' do
    FakeBilling.stub_subscription suspended: true

    expect_any_instance_of(Iugu::Subscription).to receive(:activate)
    sign_in account
    visit edit_account_registration_path
    click_link 'Ativar'

    expect(page.status_code).to eq 200
  end
end
