require 'rails_helper'

RSpec.feature 'Automations' do
  let(:account) { Fabricate.create :account }

  before do |example|
    if example.metadata[:skip_validation]
      allow_any_instance_of(DomainValidator).to receive(:validate_each)
    end
  end

  scenario 'user sees an error message' do
    sign_in account
    visit new_automation_path

    fill_form
    click_button 'Create Automation'

    expect(page).to have_content flash_message(:alert, :create)
    expect(page).to have_title 'New automation'
    expect(page.status_code).to eq 200
  end

  scenario 'user creates automation', :skip_validation do
    sign_in account
    visit new_automation_path
    fill_form
    click_button 'Create Automation'

    expect(page).to have_current_path automations_path
    expect(page).to have_content flash_message(:notice, :create)
    expect(page).to have_title 'Automation'
    expect(page.status_code).to eq 200
  end

  scenario 'user updates automation', :skip_validation do
    automation = Fabricate.create :automation, account: account

    sign_in account
    visit edit_automation_path(automation)
    fill_form
    click_button 'Update Automation'

    expect(page).to have_current_path automations_path
    expect(page).to have_content flash_message(:notice, :update)
    expect(page).to have_title 'Automation'
    expect(page.status_code).to eq 200
  end

  scenario 'user deletes automation', :skip_validation do
    automation = Fabricate.create :automation, account: account

    sign_in account
    visit automations_path
    find('.icon[data-method=delete]').click

    expect(Automation).to_not exist automation.id
    expect(page).to have_content flash_message(:notice, :destroy)
    expect(page).to have_current_path automations_path
    expect(page.status_code).to eq 200
  end

  scenario 'user pauses automation', :skip_validation do
    Fabricate.create :automation, account: account

    sign_in account
    visit automations_path
    find('.icon[data-balloon=Pause]').click

    expect(page).to have_content flash_message(:notice, :pause)
    expect(page).to have_current_path automations_path
    expect(page.status_code).to eq 200
  end

  scenario 'user resumes automation', :skip_validation do
    Fabricate.create :automation, account: account, state: :paused

    sign_in account
    visit automations_path
    find('.icon[data-balloon=Resume]').click

    expect(page).to have_content flash_message(:notice, :resume)
    expect(page).to have_current_path automations_path
    expect(page.status_code).to eq 200
  end

  def fill_form
    params = Fabricate.attributes_for :automation
    within '.simple_form' do
      fill_in 'Name', with: params[:name]
      fill_in 'Subject', with: params[:subject]
      fill_in 'From name', with: params[:from_name]
      fill_in 'From email', with: params[:from_email]
      fill_in 'automation_html_text', with: params[:html_text]
      fill_in 'automation_plain_text', with: params[:plain_text]
    end
  end

  def flash_message(type, action)
    I18n.t "flash.actions.#{action}.#{type}", resource_name: 'Automation'
  end
end
