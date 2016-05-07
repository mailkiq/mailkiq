class Message < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :campaign, counter_cache: true
  has_many :notifications
end
