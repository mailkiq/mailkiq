class Message < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :campaign
  has_many :notifications, foreign_key: :message_uid, primary_key: :uid,
                           dependent: :delete_all

  scope :opened, -> { where.not opened_at: nil }
  scope :clicked, -> { where.not clicked_at: nil }
end
