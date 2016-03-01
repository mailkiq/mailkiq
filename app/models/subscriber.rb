class Subscriber < ActiveRecord::Base
  extend Sortable
  include Person

  validates_presence_of :name
  validates_uniqueness_of :email, scope: :account_id
  validates :email, presence: true, email: true
  belongs_to :account
  has_many :messages, dependent: :delete_all
  has_many :taggings, dependent: :delete_all
  has_many :tags, through: :taggings
  enum state: %i(active unconfirmed unsubscribed bounced complained deleted)
  paginates_per 10

  scope :recents, -> { order created_at: :desc }
  scope :actived, -> { where state: states[:active] }

  auto_strip_attributes :name, :email

  def interpolations
    {
      first_name: first_name,
      last_name: last_name,
      full_name: name
    }
  end
end
