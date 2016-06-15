class Campaign < ActiveRecord::Base
  include AASM
  extend Sortable

  validates :from_email, presence: true, email: true, domain: true
  validates_presence_of :name, :subject, :from_name
  validates_presence_of :html_text, unless: :plain_text?
  validates_presence_of :plain_text, unless: :html_text?

  validates_uniqueness_of :name, scope: :account_id
  validate :validate_from_field, if: :from?

  enum state: [:draft, :queued, :sending, :paused, :sent]

  belongs_to :account
  has_many :messages

  default_scope -> { where type: '' }
  scope :recent, -> { order created_at: :desc }

  delegate :aws_options, :domain_names, :expired?,
           to: :account, prefix: true, allow_nil: true

  store_accessor :send_settings, :tagged_with, :not_tagged_with, :finished_at

  strip_attributes only: [:name, :subject, :from_name, :from_email]

  aasm column: :state, enum: true, skip_validation_on_save: true, requires_lock: 'FOR UPDATE NOWAIT' do
    state :draft, initial: true
    state :queued
    state :sending
    state :paused
    state :sent

    event :enqueue do
      transitions from: :draft, to: :queued
    end

    event :deliver do
      before do
        self.sent_at = Time.now
      end

      transitions from: :queued, to: :sending
    end

    event :pause do
      transitions from: :sending, to: :paused
    end

    event :resume do
      transitions from: :paused, to: :sending
    end

    event :finish do
      before do
        self.finished_at = Time.now
      end

      transitions from: :sending, to: :sent
    end
  end

  def viewable?
    !draft?
  end

  def editable?
    draft? || paused?
  end

  def processing?
    queued? || sending?
  end

  def messages_count
    @messages_count ||= messages.count
  end

  def deliveries_count
    [recipients_count, messages_count].min
  end

  def unsent_count
    [0, recipients_count - messages_count].max
  end

  def to_percentage(counter_name)
    counter = send(counter_name)
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
      campaign.name = "#{name} copy"
      campaign.reset_attributes!
    end
  end

  def reset_attributes!
    assign_attributes sent_at: nil,
                      recipients_count: 0,
                      unique_opens_count: 0,
                      unique_clicks_count: 0,
                      bounces_count: 0,
                      complaints_count: 0,
                      state: self.class.states[:draft],
                      send_settings: {},
                      trigger_settings: {}
  end

  private

  def validate_from_field
    Mail::FromField.new(from)
  rescue Mail::Field::ParseError
    errors.add :from_name, :unstructured_from
  end
end
