class Domain < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates_presence_of :verification_token, :status
  belongs_to :account
  enum status: [:pending, :success, :failed, :temporary_failure, :not_started]
  before_create :verify_domain_identity
  before_destroy :delete_identity
  delegate :credentials, to: :account, prefix: true
  alias_attribute :txt_value, :verification_token

  def txt_name
    "_amazonses.#{name}"
  end

  def sync_verification_status!
    response = ses.get_identity_verification_attributes([name])
    response.body['VerificationAttributes'].each do |domain|
      update_column :status, domain['VerificationStatus'].underscore
    end
  end

  private

  def ses
    @ses ||= Fog::AWS::SES.new(account_credentials)
  end

  def verify_domain_identity
    response = ses.verify_domain_identity(name)
    self.status = self.class.statuses[:pending]
    self.verification_token = response.body['VerificationToken']
  end

  def delete_identity
    ses.delete_identity(name)
  end
end
