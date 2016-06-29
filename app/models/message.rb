class Message < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :campaign
  belongs_to :automation, foreign_key: :campaign_id, counter_cache: :recipients_count
  has_many :notifications
  enum state: [:pending, :bounce, :complaint, :delivery]

  delegate :name, to: :campaign, prefix: true
  delegate :html_text, :plain_text, to: :campaign
  delegate :subscription_token, to: :subscriber

  after_initialize :generate_token

  def save_with_uuid!(uuid)
    assign_attributes uuid: uuid, sent_at: Time.now
    save!
  end

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(32).gsub(/[\-_]/, '').first(32)
  end
end
