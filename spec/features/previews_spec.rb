require 'rails_helper'

RSpec.feature 'User previewing campaign' do
  before do
    allow_any_instance_of(DomainValidator).to receive(:validate_each)
  end

  scenario 'renders campaign HTML content' do
    account = Fabricate.create :account
    campaign = Fabricate.create :campaign, account: account
    sign_in account
    visit campaign_preview_path(campaign)

    expect(page.body).to eq(campaign.html_text)
    expect(page.status_code).to eq(200)
  end
end
