require 'rails_helper'

RSpec.feature 'Campaigns' do
  let(:account) { Fabricate.create :account }

  before do |example|
    if example.metadata[:skip_validation]
      allow_any_instance_of(DomainValidator).to receive(:validate_each)
    end
  end

  scenario 'user views campaign metrics', :skip_validation do
    campaign = Fabricate.create :campaign, account: account

    sign_in account
    visit campaign_path(campaign)

    expect(page).to have_title campaign.name
    expect(page).to have_selector '.metrics'
    expect(page).to have_selector '.rates'
    expect(page.status_code).to eq 200
  end

  scenario 'user sees an error message' do
    sign_in account
    visit new_campaign_path

    fill_form
    click_button 'Create Campaign'

    expect(page).to have_content flash_message(:alert, :create)
    expect(page).to have_title 'New campaign'
    expect(page.status_code).to eq 200
  end

  scenario 'user creates campaign', :skip_validation do
    sign_in account
    visit new_campaign_path
    fill_form
    click_button 'Create Campaign'

    expect(page).to have_current_path campaigns_path
    expect(page).to have_content flash_message(:notice, :create)
    expect(page).to have_title 'Campaigns'
    expect(page.status_code).to eq 200
  end

  scenario 'user updates campaign', :skip_validation do
    campaign = Fabricate.create :campaign, account: account

    sign_in account
    visit edit_campaign_path(campaign)
    fill_form
    click_button 'Update Campaign'

    expect(page).to have_current_path campaigns_path
    expect(page).to have_content flash_message(:notice, :update)
    expect(page).to have_title 'Campaigns'
    expect(page.status_code).to eq 200
  end

  scenario 'user deletes campaign', :skip_validation do
    campaign = Fabricate.create :campaign, account: account

    sign_in account
    visit campaigns_path
    click_on 'Delete'

    expect(Campaign).to_not exist campaign.id
    expect(page).to have_content flash_message(:notice, :destroy)
    expect(page).to have_current_path campaigns_path
    expect(page.status_code).to eq 200
  end

  scenario 'user duplicates campaign', :skip_validation do
    Fabricate.create :campaign, account: account

    sign_in account
    visit campaigns_path
    click_on 'Duplicate'

    expect(page).to have_content t('flash.campaigns.duplicate.notice')
    expect(page).to have_content 'copy'
    expect(page).to have_current_path campaigns_path
    expect(page.status_code).to eq 200
  end

  def fill_form
    params = Fabricate.attributes_for :freeletics_campaign
    within '.simple_form' do
      fill_in 'Name', with: params[:name]
      fill_in 'Subject', with: params[:subject]
      fill_in 'From name', with: params[:from_name]
      fill_in 'From email', with: params[:from_email]
      fill_in 'campaign_html_text', with: params[:html_text]
      fill_in 'campaign_plain_text', with: params[:plain_text]
    end
  end

  def flash_message(type, action)
    I18n.t "flash.actions.#{action}.#{type}", resource_name: 'Campaign'
  end
end
