PayPal::Recurring.configure do |config|
  secrets = Rails.application.secrets
  config.sandbox = true
  config.username = secrets[:paypal_username]
  config.password = secrets[:paypal_password]
  config.signature = secrets[:paypal_signature]
end
