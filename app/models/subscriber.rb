class Subscriber < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :email, scope: :account_id
  validates :email, presence: true, email: true
  belongs_to :account
  has_many :messages, dependent: :delete_all
  enum state: [:active, :unconfirmed, :unsubscribed, :bounced, :deleted]
  paginates_per 25

  def first_name
    name.split(' ').first
  end

  def last_name
    name.split(' ')[1..-1].join(' ')
  end

  def interpolations
    {
      first_name: first_name,
      last_name: last_name,
      full_name: name
    }
  end
end
