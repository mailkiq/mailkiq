require 'rails_helper'

RSpec.feature 'User updating settings' do
  scenario 'changes credentials' do
    account = Fabricate.create :account

    expect(DomainJob).to receive(:enqueue).with(account.id).twice

    sign_in account
    visit edit_settings_path

    within '.edit_account' do
      fill_in 'Access Key ID', with: 'new_key_id'
      fill_in 'Secret Access Key', with: 'new_secret'
      select 'EU (Ireland)', from: 'Amazon SES Region'
      click_button 'Change'
    end

    account.reload

    expect(account.aws_access_key_id).to eq('new_key_id')
    expect(account.aws_secret_access_key).to eq('new_secret')
    expect(account.aws_region).to eq('eu-west-1')

    expect(page).to have_current_path edit_settings_path
    expect(page).to have_selector '.flash-notice'
    expect(page.status_code).to eq 200
  end
end
