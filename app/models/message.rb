class Message < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :campaign
end
