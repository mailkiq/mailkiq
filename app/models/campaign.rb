class Campaign < ActiveRecord::Base
  validates_presence_of :name, :subject, :from_name, :html_text
  validates :from_email, presence: true, email: true,
                         identity: { credentials: :account_credentials,
                                     domains: :account_domain_names }

  has_many :messages, dependent: :delete_all
  belongs_to :account
  before_destroy :clear_sidekiq_queue

  delegate :credentials, :domain_names, to: :account, prefix: true
  delegate :count, to: :messages, prefix: true

  scope :recents, -> { order created_at: :desc }

  def self.sort(column, direction)
    if column_names.include?(column) && %w(asc desc).include?(direction)
      order column => direction
    else
      recents
    end
  end

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
