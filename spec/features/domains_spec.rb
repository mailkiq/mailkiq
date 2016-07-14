require 'rails_helper'

RSpec.feature 'Domains' do
  let(:account) { Fabricate.create :account }

  scenario 'user creates a domain' do
    sign_in account
    visit edit_settings_path

    within '.new_domain' do
      fill_in 'Name', with: 'example.com'
      click_button 'Create Domain'
    end

    expect(account.domains.first).to have_attributes name: 'example.com'

    expect(page).to have_selector '.flash-notice'
    expect(page).to have_content 'example.com'
    expect(page).to have_title 'Amazon Simple Email Service'
    expect(page).to have_current_path edit_settings_path
    expect(page.status_code).to eq 200
  end

  scenario 'can delete their own domain' do
    domain = Fabricate.build :valid_domain, account: account

    sign_in account
    visit domain_path(domain)
    click_link 'Delete Domain'

    expect(Domain).to_not exist domain.id

    expect(page).to have_current_path edit_settings_path
    expect(page).to have_selector '.flash-notice'
    expect(page.status_code).to eq 200
  end

  scenario "cannot view someone else's domain" do
    other_account = Fabricate.create :jane_doe
    domain = Fabricate.build :valid_domain, account: other_account

    sign_in account

    expect { visit domain_path(domain) }
      .to raise_exception ActiveRecord::RecordNotFound
  end
end
