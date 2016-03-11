class Domain < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_insensitive: true }
  belongs_to :account
  enum status: [:pending, :success, :failed, :temporary_failure, :not_started]
  delegate :credentials, to: :account, prefix: true
  alias_attribute :txt_value, :verification_token

  scope :succeed, -> { where status: statuses[:success] }

  def self.domain_names
    succeed.pluck(:name)
  end

  def txt_name
    "_amazonses.#{name}"
  end
end
