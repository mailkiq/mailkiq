require 'rails_helper'

RSpec.feature 'Deliveries' do
  let(:account) { Fabricate.create :account }
  let(:campaign) { Fabricate.create :campaign, account: account }

  before do
    allow_any_instance_of(DomainValidator).to receive(:validate_each)
    sign_in account
  end

  context 'with expired account' do
    scenario 'enqueues mass sending email process' do
      visit new_campaign_delivery_path(campaign)
      expect_any_instance_of(Delivery).to receive(:enqueue!)
      click_button 'Enviar'

      expect(page).to have_content t('flash.deliveries.create.alert')
      expect(page.status_code).to eq 200
    end
  end

  context 'with valid params' do
    scenario 'enqueues mass sending email process' do
      visit new_campaign_delivery_path(campaign)
      expect_any_instance_of(Delivery).to receive(:enqueue!)
      expect_any_instance_of(Delivery).to receive(:processing?).and_return(true)
      click_button 'Enviar'

      expect(page).to have_content t('flash.deliveries.create.notice')
      expect(page.status_code).to eq 200
    end
  end
end
