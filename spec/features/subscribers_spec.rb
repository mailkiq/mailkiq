require 'rails_helper'

RSpec.feature 'Subscribers' do
  let(:account) { Fabricate.create :account }

  scenario 'user creates subscriber' do
    sign_in account
    visit new_subscriber_path
    fill_in 'subscriber_email', with: 'teste@teste.com'
    click_button 'Create Subscriber'

    expect(page).to have_current_path subscribers_path
    expect(page).to have_content flash_message(:notice, :create)
    expect(page).to have_title 'Subscribers'
    expect(page.status_code).to eq 200
  end

  scenario 'user updates subscriber' do
    subscriber = Fabricate.create :subscriber, account: account

    sign_in account
    visit edit_subscriber_path(subscriber)
    fill_in 'subscriber_name', with: 'John Doe'
    click_button 'Update Subscriber'

    expect(page).to have_current_path subscribers_path
    expect(page).to have_content flash_message(:notice, :update)
    expect(page).to have_title 'Subscribers'
    expect(page.status_code).to eq 200
  end

  scenario 'user deletes subscriber' do
    subscriber = Fabricate.create :subscriber, account: account

    sign_in account
    visit subscribers_path
    find('.icon[data-method=delete]').click

    expect(Subscriber).to_not exist subscriber.id
    expect(page).to have_content flash_message(:notice, :destroy)
    expect(page).to have_current_path subscribers_path
    expect(page.status_code).to eq 200
  end

  def flash_message(type, action)
    I18n.t "flash.actions.#{action}.#{type}", resource_name: 'Subscriber'
  end
end
