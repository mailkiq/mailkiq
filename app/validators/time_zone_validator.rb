class TimeZoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless ActiveSupport::TimeZone[value].present?
      record.errors[attribute] << (options[:message] || 'does not exist')
    end
  end
end
