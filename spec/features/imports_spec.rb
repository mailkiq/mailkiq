require 'rails_helper'

RSpec.feature 'Imports' do
  let(:account) { Fabricate.create :account }

  scenario 'user imports subscribers' do
    sign_in account
    visit new_import_path
    fill_in 'import_csv', with: 'teste@teste.com'
    click_button 'Import'

    expect(account.subscribers.count).to eq(1)
    expect(page).to have_title 'Add new subscribers'
    expect(page.status_code).to eq 200
  end
end
