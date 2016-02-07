class Subscriber < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :email, scope: :account_id
  validates :email, presence: true, email: true
  belongs_to :account
  has_many :messages, dependent: :delete_all
  paginates_per 25

  def first_name
    name.split(' ').first
  end

  def last_name
    name.split(' ')[1..-1].join(' ')
  end
end
