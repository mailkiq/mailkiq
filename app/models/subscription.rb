class Subscription < ActiveRecord::Base
  validates_presence_of :status
  enum status: [:active, :unconfirmed, :unsubscribed, :bounced, :deleted]
  belongs_to :list
  belongs_to :subscriber
end
