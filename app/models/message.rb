class Message < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :campaign
  scope :opened, -> { where.not opened_at: nil }
  scope :clicked, -> { where.not clicked_at: nil }
end
