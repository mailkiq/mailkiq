class Domain < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_insensitive: true }
  belongs_to :account
  enum status: [:pending, :success, :failed, :temporary_failure, :not_started]
  before_create :verify_domain_identity
  before_destroy :delete_identity
  delegate :credentials, to: :account, prefix: true
  alias_attribute :txt_value, :verification_token

  scope :succeed, -> { where status: statuses[:success] }

  def self.domain_names
    succeed.pluck(:name)
  end

  def txt_name
    "_amazonses.#{name}"
  end

  def save_verification_attributes!
    response = ses.get_identity_verification_attributes([name])
    response.body['VerificationAttributes'].each do |domain|
      new_status = domain['VerificationStatus'].underscore
      self.status = self.class.statuses[new_status]
      self.verification_token = domain['VerificationToken']
    end
    save!
  end

  def verify_domain_identity
    response = ses.verify_domain_identity(name)
    self.status = self.class.statuses[:pending]
    self.verification_token = response.body['VerificationToken']
  end

  private

  def ses
    @ses ||= Fog::AWS::SES.new(account_credentials)
  end

  def delete_identity
    ses.delete_identity(name)
  end
end
