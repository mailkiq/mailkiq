class Subscriber < ActiveRecord::Base
  include Sortable
  include Person

  validates_presence_of :name
  validates_uniqueness_of :email, scope: :account_id
  validates :email, presence: true, email: true
  belongs_to :account
  has_many :messages
  has_many :taggings
  has_many :tags, through: :taggings
  enum state: %i(active unconfirmed unsubscribed bounced complained deleted)
  paginates_per 10

  scope :actived, -> { where state: states[:active] }

  strip_attributes only: [:name, :email]

  def subscription_token
    @subscription_token ||= Token.encode(id)
  end

  def guess_name!
    self.name = email.split('@').first
  end

  def interpolations
    {
      first_name: first_name,
      last_name: last_name,
      full_name: name
    }
  end
end
