class Campaign < ActiveRecord::Base
  validates_presence_of :name, :subject, :from_name, :html_text
  validates :from_email, presence: true, email: true
  validates_with IdentityValidator, if: :account_id?
  has_many :messages, dependent: :delete_all
  belongs_to :account
  delegate :credentials, to: :account

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
end
