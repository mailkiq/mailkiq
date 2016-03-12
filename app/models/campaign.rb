class Campaign < ActiveRecord::Base
  include Sortable

  validates_presence_of :name, :subject, :from_name, :html_text
  validates :from_email, presence: true, email: true, domain: true

  has_many :messages, dependent: :delete_all
  belongs_to :account

  delegate :credentials, :domain_names, to: :account, prefix: true

  auto_strip_attributes :name, :subject, :from_name, :from_email

  def sender
    "#{from_name} <#{from_email}>"
  end

  def queue_name
    "campaign-#{id}"
  end
end
