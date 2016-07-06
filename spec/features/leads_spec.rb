require 'rails_helper'

RSpec.feature 'Visitor subscribes email', type: :feature do
  scenario 'they see a confirmation message' do
    account = Fabricate.create :official_account

    visit '/'
    fill_in 'lead_email', with: 'mary@doe.com'
    click_button 'Enviar'

    expect(account.subscribers.first)
      .to have_attributes email: 'mary@doe.com', state: 'unconfirmed', name: nil

    expect(page).to have_title 'Mailkiq'
    expect(page).to have_selector 'p.notice'
    expect(page.status_code).to eq 200
  end
end
