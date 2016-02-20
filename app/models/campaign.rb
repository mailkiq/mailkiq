class Campaign < ActiveRecord::Base
  validates_presence_of :name, :subject, :from_name, :html_text
  validates :from_email, presence: true, email: true
  validates_with IdentityValidator, if: :account_id?
  has_many :messages, dependent: :delete_all
  belongs_to :account
  before_destroy :clear_sidekiq_queue

  delegate :credentials, to: :account, allow_nil: true
  delegate :count, to: :messages, prefix: true

  scope :recents, -> { order created_at: :desc }

  def sender
    "#{from_name} <#{from_email}>"
  end

  def queue_name
    "campaign-#{id}"
  end

  def unique_opens_count
    messages.opened.count
  end

  def unique_clicks_count
    messages.clicked.count
  end

  private

  def clear_sidekiq_queue
    Sidekiq::Queue.new(queue_name).clear
  end
end
