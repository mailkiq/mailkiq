Clearance.configure do |config|
  config.mailer_sender = 'noreply@mailkiq.com'
  config.routes = false
  config.user_model = Account
end
