class Account < ActiveRecord::Base
  include AASM
  include Person

  LANGUAGES = %w(en pt-BR).freeze
  REGIONS = %w(us-east-1 us-west-2 eu-west-1).freeze

  validates_presence_of :name, :aws_access_key_id, :aws_secret_access_key
  validates_inclusion_of :language, in: LANGUAGES, allow_blank: true
  validates_inclusion_of :aws_region, in: REGIONS, allow_blank: true
  validates :time_zone, time_zone: true, if: :time_zone?
  validates_with AccessKeysValidator, if: :validate_access_keys?
  validate :validate_plan, if: :force_plan_validation

  has_many :campaigns
  has_many :subscribers
  has_many :tags
  has_many :domains, dependent: :destroy
  has_many :automations

  delegate :domain_names, to: :domains
  delegate :remaining, :exceed?, to: :quota, prefix: true

  attr_accessor :force_password_validation, :force_plan_validation,
                :credit_card_token, :plan

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable

  scope :active, -> { where.not aws_queue_url: nil, aws_topic_arn: nil }

  def self.new_with_session(params, session)
    super.tap do |account|
      secrets = Rails.application.secrets
      account.force_plan_validation = true
      account.language = 'pt-BR'
      account.time_zone = 'Brasilia'
      account.aws_access_key_id = secrets[:aws_access_key_id]
      account.aws_secret_access_key = secrets[:aws_secret_access_key]
    end
  end

  def remember_me
    true
  end

  def password_required?
    @force_password_validation || super
  end

  def quota
    @quota ||= Quota.new(self)
  end

  def tied_to_mailkiq?
    secrets = Rails.application.secrets
    aws_access_key_id == secrets[:aws_access_key_id] &&
      aws_secret_access_key == secrets[:aws_secret_access_key]
  end

  def aws_options
    options = HashWithIndifferentAccess.new
    options[:region] = aws_region || 'us-east-1'
    options[:access_key_id] = aws_access_key_id
    options[:secret_access_key] = aws_secret_access_key
    options[:stub_responses] = true if Rails.env.test?
    options
  end

  private

  def validate_plan
    Iugu::Plan.fetch_by_identifier(plan)
  rescue Iugu::ObjectNotFound
    errors.add :base, :invalid_plan
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
