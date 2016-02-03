class Account < ActiveRecord::Base
  include Clearance::User

  LANGUAGES = %w(en pt-BR)
  REGIONS = %w(us-east-1 us-west-2 eu-west-1)

  validates_presence_of :name, :aws_access_key_id, :aws_secret_access_key
  validates_inclusion_of :language, in: LANGUAGES, allow_blank: true
  validates_inclusion_of :aws_region, in: REGIONS, allow_blank: true
  validates :time_zone, time_zone: true, if: :time_zone?
  validates_with AccessKeysValidator, if: :validate_access_keys?

  has_many :campaigns, dependent: :destroy
  has_many :subscribers, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def admin?
    email == 'rainerborene@gmail.com'
  end

  def credentials
    fog_options = slice :aws_access_key_id, :aws_secret_access_key
    fog_options.merge! region: aws_region || 'us-east-1'
    HashWithIndifferentAccess.new(fog_options)
  end

  private

  def aws_keys?
    aws_access_key_id? && aws_secret_access_key?
  end

  def aws_keys_changed?
    aws_access_key_id_changed? || aws_secret_access_key_changed?
  end

  def validate_access_keys?
    send(new_record? ? :aws_keys? : :aws_keys_changed?)
  end
end
