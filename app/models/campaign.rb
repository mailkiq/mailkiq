class Campaign < ActiveRecord::Base
  include Redis::Objects
  include Sortable

  validates :from_email, presence: true, email: true, domain: true
  validates_presence_of :name, :subject, :from_name
  validates_presence_of :html_text, unless: :plain_text?
  validates_presence_of :plain_text, unless: :html_text?

  validates_uniqueness_of :name, scope: :account_id
  validate :validate_from_field, if: :from?

  has_many :messages, dependent: :delete_all
  belongs_to :account

  scope :sent, -> { where.not sent_at: nil }

  delegate :credentials, :domain_names, to: :account, prefix: true

  strip_attributes only: [:name, :subject, :from_name, :from_email]

  counter :messages_count # aka delivery
  counter :unique_opens_count
  counter :unique_clicks_count
  counter :rejects_count
  counter :bounces_count
  counter :complaints_count

  def self.opened_campaign_names
    sent.pluck(:name).map { |name| "Opened #{name}" }
  end

  def queue
    @queue ||= CampaignQueue.new(self)
  end

  def unsent_count
    recipients_count - messages_count.value
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
                                 unique_clicks_count: 0
    end
  end

  private

  def validate_from_field
    Mail::FromField.new(from)
  rescue Mail::Field::ParseError
    errors.add :from_name, :unstructured_from
  end
end
