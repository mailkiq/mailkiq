class Campaign < ActiveRecord::Base
  extend Sortable

  validates :from_email, presence: true, email: true, domain: true
  validates_presence_of :name, :subject, :from_name
  validates_presence_of :html_text, unless: :plain_text?
  validates_presence_of :plain_text, unless: :html_text?

  validates_uniqueness_of :name, scope: :account_id
  validate :validate_from_field, if: :from?

  belongs_to :account
  has_many :messages
  has_many :automations

  scope :sent, -> { where.not sent_at: nil }
  scope :unsent, -> { where sent_at: nil }
  scope :recent, -> { order created_at: :desc }

  delegate :aws_options, :domain_names, to: :account, prefix: true
  delegate :count, to: :messages, prefix: true

  strip_attributes only: [:name, :subject, :from_name, :from_email]

  def deliveries_count
    [recipients_count, messages_count].min
  end

  def unsent_count
    [0, recipients_count - messages_count].max
  end

  def to_percentage(counter_name)
    counter = send(counter_name)
    counter = counter.value if counter.respond_to?(:value)
    counter.to_f / [1, recipients_count].max * 100
  end

  def from
    "#{from_name} <#{from_email}>"
  end

  def from?
    from_name? && from_email?
  end

  def duplicate
    dup.tap do |campaign|
      campaign.assign_attributes name: "#{name} copy",
                                 sent_at: nil,
                                 recipients_count: 0,
                                 unique_opens_count: 0,
                                 unique_clicks_count: 0,
                                 bounces_count: 0,
                                 complaints_count: 0
    end
  end

  private

  def validate_from_field
    Mail::FromField.new(from)
  rescue Mail::Field::ParseError
    errors.add :from_name, :unstructured_from
  end
end
