class Domain < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  belongs_to :account

  enum verification_status: [
    :pending, :success, :failed, :temporary_failure, :not_started
  ]

  enum dkim_verification_status: [
    :dkim_pending, :dkim_success, :dkim_failed, :dkim_temporary_failure,
    :dkim_not_started
  ]

  enum mail_from_domain_status: [
    :mail_from_pending, :mail_from_success, :mail_from_failed,
    :mail_from_temporary_failure
  ]

  delegate :verify!, :update!, :delete!, to: :identity, prefix: true
  delegate :aws_options, :aws_topic_arn, to: :account, prefix: true

  def self.succeed
    where verification_status: verification_statuses[:success]
  end

  def self.domain_names
    succeed.pluck(:name)
  end

  def identity
    @identity ||= DomainIdentity.new(self)
  end

  def records
    @records ||= DomainRecords.new(self)
  end

  def all_pending!
    self.verification_status = :pending
    self.dkim_verification_status = :dkim_pending
    self.mail_from_domain_status = :mail_from_pending
  end
end
