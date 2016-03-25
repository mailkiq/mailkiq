class Plan < ActiveRecord::Base
  validates_presence_of :name, :price
  has_many :accounts

  def self.find_basic
    find_by name: 'Basic'
  end
end
