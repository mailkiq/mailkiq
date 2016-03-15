class Campaign < ActiveRecord::Base
  include Sortable

  validates :from_email, presence: true, email: true, domain: true
  validates_presence_of :name, :subject, :from_name, :html_text
  validates_uniqueness_of :name, case_insensitive: true, scope: :account_id
  validate :validate_from_field, if: :from_fields?

  has_many :messages, dependent: :delete_all
  belongs_to :account

  delegate :credentials, :domain_names, to: :account, prefix: true

  auto_strip_attributes :name, :subject, :from_name, :from_email

  def from
    "#{from_name} <#{from_email}>"
  end

  def queue_name
    "campaign-#{id}"
  end

  private

  def from_fields?
    from_name? && from_email?
  end

  def validate_from_field
    Mail::FromField.new(from)
  rescue Mail::Field::ParseError
    errors.add :from_name, :unstructured_from
  end
end
