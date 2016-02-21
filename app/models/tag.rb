class Tag < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :slug, case_sensitive: false, scope: :account_id
  before_validation :set_slug, if: :name?
  belongs_to :account
  has_many :taggings, dependent: :delete_all
  has_many :subscribers, through: :taggings

  private

  def set_slug
    self.slug = name.parameterize
  end
end
