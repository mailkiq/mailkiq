class Domain < ActiveRecord::Base
  validates_presence_of :name, :verification_token, :status
  belongs_to :account
  enum status: [:pending, :success, :failed, :temporary_failure, :not_started]
  before_create :verify_domain_identity
  delegate :credentials, to: :account, allow_nil: true

  private

  def verify_domain_identity
    ses = Fog::AWS::SES.new credentials
    response = ses.verify_domain_identity(name)
    self.status = self.class.statuses[:pending]
    self.verification_token = response.body['VerificationToken']
  end

  def delete_identity
  end
end
