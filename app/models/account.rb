class Account < ActiveRecord::Base
  include Person

  LANGUAGES = %w(en pt-BR).freeze
  REGIONS = %w(us-east-1 us-west-2 eu-west-1).freeze

  validates_presence_of :name, :aws_access_key_id, :aws_secret_access_key, :plan
  validates_inclusion_of :language, in: LANGUAGES, allow_blank: true
  validates_inclusion_of :aws_region, in: REGIONS, allow_blank: true
  validates :time_zone, time_zone: true, if: :time_zone?
  validates_with AccessKeysValidator, if: :validate_access_keys?

  belongs_to :plan
  has_many :campaigns
  has_many :subscribers
  has_many :tags
  has_many :domains, dependent: :destroy
  has_many :automations

  after_commit :create_topic, on: :create
  after_commit :delete_topic, on: :destroy

  delegate :domain_names, to: :domains
  delegate :credits, to: :plan, prefix: true
  delegate :remaining, :exceed?, to: :quota, prefix: true

  attr_accessor :force_password_validation
  attr_accessor :paypal_payment_token

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable

  scope :active, -> { where.not aws_queue_url: nil, aws_topic_arn: nil }

  def remember_me
    true
  end

  def password_required?
    @force_password_validation || super
  end

  def quota
    @quota ||= Quota.new(self)
  end

  def paypal
    @paypal ||= Payment.new(self)
  end

  def paypal?
    paypal_payment_token.present? && paypal_customer_token?
  end

  def tied_to_mailkiq?
    secrets = Rails.application.secrets
    aws_access_key_id == secrets[:aws_access_key_id] &&
      aws_secret_access_key == secrets[:aws_secret_access_key]
  end

  def aws_options
    options = ActiveSupport::HashWithIndifferentAccess.new
    options[:region] = aws_region || 'us-east-1'
    options[:access_key_id] = aws_access_key_id
    options[:secret_access_key] = aws_secret_access_key
    options[:stub_responses] = true if Rails.env.test?
    options
  end

  def mixpanel_properties
    {
      :$first_name => first_name,
      :$last_name  => last_name,
      :$created    => created_at,
      :$email      => email
    }
  end

  private

  def create_topic
    ActivationJob.enqueue id, :activate
  end

  def delete_topic
    ActivationJob.enqueue id, :deactivate
  end

  def validate_access_keys?
    if tied_to_mailkiq?
      false
    elsif new_record?
      aws_access_key_id? && aws_secret_access_key?
    else
      aws_access_key_id_changed? || aws_secret_access_key_changed?
    end
  end
end
