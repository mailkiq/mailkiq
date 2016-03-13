class Domain < ActiveRecord::Base
  CNAME = Struct.new(:name, :value)

  validates :name, presence: true, uniqueness: { case_insensitive: true }
  belongs_to :account
  enum status: [:pending, :success, :failed, :temporary_failure, :not_started]
  alias_attribute :txt_value, :verification_token

  delegate :verify!, :delete!, to: :identity, prefix: true

  scope :succeed, -> { where status: statuses[:success] }

  def self.domain_names
    succeed.pluck(:name)
  end

  def identity
    DomainIdentity.new(self)
  end

  def txt_name
    "_amazonses.#{name}"
  end

  def cname_records
    dkim_tokens.map do |token|
      CNAME.new("#{token}._domainkey.#{name}", "#{token}.dkim.amazonses.com")
    end
  end
end
