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
    %i(active unconfirmed unsubscribed bounced complained deleted invalid_email)

  paginates_per 10

  scope :actived, -> { where state: states[:active] }
  scope :recent, -> { order created_at: :desc }

  strip_attributes only: [:name, :email]

  before_create :set_default_state

  def self.mark_as_invalid_email(id)
    where(id: id).update_all state: Subscriber.states[:invalid_email]
  end

  def self.update_state_for(state, email:, account_id:)
    where(email: email, account_id: account_id)
      .update_all(state: Subscriber.states[state])
  end

  def merge_tags!(name)
    self.tag_ids = tag_ids | tags.where(slug: name).pluck(:id)
  end

  def subscribe!
    update! unsubscribed_at: nil, state: :active
  end

  def unsubscribe!
    update! unsubscribed_at: Time.now, state: :unsubscribed
  end

  protected

  def set_default_state
    self.state ||= self.class.states[:unconfirmed]
  end
end
