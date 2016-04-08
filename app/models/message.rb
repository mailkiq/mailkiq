class Message < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :campaign, counter_cache: true
  has_many :notifications

  scope :opened, -> { where.not opened_at: nil }
  scope :clicked, -> { where.not clicked_at: nil }

  def unopened?
    !opened_at?
  end

  def unclicked?
    !clicked_at?
  end

  def see!(request)
    self.opened_at = Time.zone.now
    self.referer = request.referer
    self.ip_address = request.remote_ip
    self.user_agent = request.user_agent
    save!
  end

  def click!(request)
    self.clicked_at = Time.zone.now
    self.opened_at ||= clicked_at
    self.referer ||= request.referer
    self.ip_address ||= request.remote_ip
    self.user_agent ||= request.user_agent
    save!
  end
end
