require 'rails_helper'

RSpec.feature 'Tags' do
  let(:account) { Fabricate.create :account }

  scenario 'user creates tag' do
    sign_in account
    visit new_tag_path
    fill_in 'Name', with: 'something'
    click_button 'Create Tag'

    expect(page).to have_current_path tags_path
    expect(page).to have_content flash_message(:notice, :create)
    expect(page).to have_title 'Tags'
    expect(page.status_code).to eq 200
  end

  scenario 'user updates tag' do
    tag = Fabricate.create :tag, account: account

    sign_in account
    visit edit_tag_path(tag)
    fill_in 'Name', with: 'something'
    click_button 'Update Tag'

    expect(page).to have_current_path tags_path
    expect(page).to have_content flash_message(:notice, :update)
    expect(page).to have_title 'Tags'
    expect(page.status_code).to eq 200
  end

  scenario 'user deletes tag' do
    tag = Fabricate.create :tag, account: account

    sign_in account
    visit tags_path
    find('.icon[data-method=delete]').click

    expect(Tag).to_not exist tag.id
    expect(page).to have_content flash_message(:notice, :destroy)
    expect(page).to have_current_path tags_path
    expect(page.status_code).to eq 200
  end

  def flash_message(type, action)
    I18n.t "flash.actions.#{action}.#{type}", resource_name: 'Tag'
  end
end
