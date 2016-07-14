require 'rails_helper'

RSpec.feature 'User updating account' do
  let(:account) { Fabricate.create :account }

  before do
    allow_any_instance_of(AccessKeysValidator).to receive(:validate)

    stub_request(:get, 'https://api.iugu.com/v1/plans')
      .to_return(body: fixture_file('iugu_plans.json'))
  end

  scenario 'changes name and email fields' do
    sign_in account
    visit edit_account_registration_path
    within '.profile .edit_account:first' do
      fill_in 'Full Name', with: 'John Doe'
      fill_in 'Email', with: 'john@doe.com'
      click_button 'Save Changes'
    end

    expect(account.reload)
      .to have_attributes name: 'John Doe', email: 'john@doe.com'
    expect(page).to have_current_path edit_account_registration_path
    expect(page).to have_selector '.flash-notice'
  end

  scenario 'changes current password' do
    sign_in account
    visit edit_account_registration_path
    within '.profile .edit_account:last' do
      fill_in 'Current password', with: 'testando'
      fill_in 'New password', with: 'new_password'
      fill_in 'Password confirmation', with: 'new_password'
      click_button 'Update Password'
    end

    expect(account.reload).to be_valid_password 'new_password'
    expect(page).to have_current_path edit_account_registration_path
    expect(page).to have_selector '.flash-notice'
    expect(page.status_code).to eq 200
  end
end
