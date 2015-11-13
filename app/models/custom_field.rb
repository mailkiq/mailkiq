class CustomField < ActiveRecord::Base
  RESERVED_NAMES = /^(name|email)$/i

  before_validation :set_key, if: :field_name?
  validates :field_name, presence: true, length: { maximum: 30 },
                         uniqueness: { scope: :list_id }
  validates_presence_of :data_type
  validate :validate_reserved_names
  enum data_type: [:text, :number, :date]
  belongs_to :list

  def match?(value)
    /^(#{key}|#{field_name})$/i.match(value)
  end

  private

  def set_key
    self[:key] = field_name.parameterize.tr('-', '_')
  end

  def validate_reserved_names
    errors.add :field_name, :reserved if field_name =~ RESERVED_NAMES
  end
end
