PayPal::Recurring.configure do |config|
  secrets = Rails.application.secrets
  config.sandbox = secrets[:paypal_sandbox]
  config.username = secrets[:paypal_username]
  config.password = secrets[:paypal_password]
  config.signature = secrets[:paypal_signature]
end
