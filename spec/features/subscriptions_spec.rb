require 'rails_helper'

RSpec.feature 'Subscriptions' do
  let(:account) { Fabricate.create :account }
  let(:subscriber) { Fabricate.create :subscriber, account: account }

  scenario 'user subscribes' do
    subscriber.unsubscribe!
    visit subscription_path(subscriber.subscription_token)
    expect_unsubscribed
    click_link 'Resubscribe'
    expect_subscribed
  end

  scenario 'user unsubscribes' do
    visit subscription_path(subscriber.subscription_token)
    expect_subscribed
    click_link 'Unsubscribe'
    expect_unsubscribed
  end

  def expect_subscribed
    expect(page).to have_content 'You are subscribed'
    expect(page.status_code).to eq 200
  end

  def expect_unsubscribed
    expect(page).to have_content 'You are unsubscribed'
    expect(page.status_code).to eq 200
  end
end
