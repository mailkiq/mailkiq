class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :recent, -> { order created_at: :desc }
end
