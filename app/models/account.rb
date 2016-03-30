class Account < ActiveRecord::Base
  include Clearance::User
  include Person

  LANGUAGES = %w(en pt-BR).freeze
  REGIONS = %w(us-east-1 us-west-2 eu-west-1).freeze

  validates_presence_of :name, :aws_access_key_id, :aws_secret_access_key, :plan
  validates_inclusion_of :language, in: LANGUAGES, allow_blank: true
  validates_inclusion_of :aws_region, in: REGIONS, allow_blank: true
  validates :time_zone, time_zone: true, if: :time_zone?
  validates_with AccessKeysValidator, if: :validate_access_keys?
  validates_confirmation_of :password, allow_blank: true

  with_options on: :update, if: :validate_password? do
    validates_presence_of :password
    validate :current_password_is_correct
  end

  belongs_to :plan
  has_many :campaigns, dependent: :destroy
  has_many :subscribers, dependent: :delete_all
  has_many :tags, dependent: :delete_all
  has_many :domains, dependent: :destroy

  delegate :domain_names, to: :domains

  attr_accessor :current_password
  attr_accessor :paypal_payment_token

  def paypal
    Payment.new(self)
  end

  def tied_to_mailkiq?
    aws_access_key_id == ENV['MAILKIQ_ACCESS_KEY_ID'] &&
      aws_secret_access_key == ENV['MAILKIQ_SECRET_ACCESS_KEY']
  end

  def save_with_payment
    response = paypal.make_recurring
    self.paypal_recurring_profile_token = response.profile_id
    save!
  end

  def admin?
    email == 'rainerborene@gmail.com'
  end

  def credentials
    options = ActiveSupport::HashWithIndifferentAccess.new
    options[:region] = aws_region || 'us-east-1'
    options[:access_key_id] = aws_access_key_id
    options[:secret_access_key] = aws_secret_access_key
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

  def aws_keys?
    aws_access_key_id? && aws_secret_access_key?
  end

  def aws_keys_changed?
    aws_access_key_id_changed? || aws_secret_access_key_changed?
  end

  def validate_access_keys?
    if tied_to_mailkiq?
      false
    elsif new_record?
      aws_keys?
    else
      aws_keys_changed?
    end
  end

  def current_password_is_correct
    unless BCrypt::Password.new(encrypted_password_was) == current_password
      errors.add(:current_password, :incorrect)
    end
  end

  def validate_password?
    !password.nil?
  end
end
