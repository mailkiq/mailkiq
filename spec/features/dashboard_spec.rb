require 'rails_helper'

RSpec.feature 'User viewing dashboard', type: :feature do
  scenario 'shows Amazon SES metrics' do
    account = Fabricate.build :account
    stub_sign_in account
    visit '/'

    expect(page).to have_link 'Sign Out', href: destroy_account_session_path
    expect(page).to have_title 'Sending Statistics'
    expect(page).to have_selector '.panel-body[data-metrics]'
    expect(page.status_code).to eq 200
  end
end
