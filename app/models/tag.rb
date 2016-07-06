class Tag < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :slug, scope: :account_id
  before_validation :set_slug, if: :name?
  belongs_to :account
  has_many :taggings, dependent: :restrict_with_error
  has_many :subscribers, through: :taggings
  delegate :count, to: :subscribers, prefix: true
  paginates_per 10

  private

  def set_slug
    self.slug = name.parameterize
  end
end
