class Subscriber < ActiveRecord::Base
  extend Sortable
  include Person

  validates_uniqueness_of :email, scope: :account_id
  validates :email, presence: true, email: true
  belongs_to :account
  has_many :messages
  has_many :taggings
  has_many :tags, through: :taggings
  enum state:
    %i(active unconfirmed unsubscribed bounced complained deleted wrong_email)

  paginates_per 10

  scope :actived, -> { where state: states[:active] }
  scope :recent, -> { order created_at: :desc }

  strip_attributes only: [:name, :email]

  before_create :set_default_state

  def self.mark_as_wrong_email(subscriber_id)
    where(id: subscriber_id).update_all state: Subscriber.states[:wrong_email]
  end

  def interpolations
    {
      first_name: first_name,
      last_name: last_name,
      full_name: name
    }
  end

  protected

  def set_default_state
    self.state ||= self.class.states[:unconfirmed]
  end
end
