class Plan < ActiveRecord::Base
  validates_presence_of :name, :price
  has_many :accounts
end
