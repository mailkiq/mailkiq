require 'rails_helper'

describe Subscription, type: :model do
  it { is_expected.to belong_to :list }
  it { is_expected.to belong_to :subscriber }
  it do
    is_expected.to define_enum_for(:status).
      with([:active, :unconfirmed, :unsubscribed, :bounced, :deleted])
  end
end
