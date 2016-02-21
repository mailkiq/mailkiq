Raven.configure do |config|
  filter_parameters = Rails.application.config.filter_parameters.map(&:to_s)
  config.sanitize_fields = filter_parameters
end
