class Campaign < ActiveRecord::Base
  extend Sortable

  validates_presence_of :name, :subject, :from_name, :html_text
  validates :from_email, presence: true, email: true,
                         identity: { credentials: :account_credentials,
                                     domains: :account_domain_names }

  has_many :messages, dependent: :delete_all
  belongs_to :account
  before_destroy :clear_sidekiq_queue

  delegate :credentials, :domain_names, to: :account, prefix: true

  scope :recents, -> { order created_at: :desc }

  auto_strip_attributes :name, :subject, :from_name, :from_email

  def sender
    "#{from_name} <#{from_email}>"
  end

  def queue_name
    "campaign-#{id}"
  end

  private

  def clear_sidekiq_queue
    Sidekiq::Queue.new(queue_name).clear
  end
end
