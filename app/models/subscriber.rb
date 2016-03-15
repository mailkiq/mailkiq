class Subscriber < ActiveRecord::Base
  include Sortable
  include Person

  validates_presence_of :name
  validates_uniqueness_of :email, case_sensitive: false, scope: :account_id
  validates :email, presence: true, email: true
  belongs_to :account
  has_many :messages, dependent: :delete_all
  has_many :taggings, dependent: :delete_all
  has_many :tags, through: :taggings
  enum state: %i(active unconfirmed unsubscribed bounced complained deleted)
  paginates_per 10

  scope :actived, -> { where state: states[:active] }

  auto_strip_attributes :name, :email

  def subscription_token
    @subscription_token ||= Token.encode(id)
  end

  def interpolations
    {
      first_name: first_name,
      last_name: last_name,
      full_name: name
    }
  end
end
