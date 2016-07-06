class Domain < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  belongs_to :account

  states = [:pending, :success, :failed, :temporary_failure, :not_started]
  enum verification_status: states
  enum dkim_verification_status: states, _prefix: :dkim
  enum mail_from_domain_status: states, _prefix: :mail_from

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
    self.dkim_verification_status = :pending
    self.mail_from_domain_status = :pending
  end
end
