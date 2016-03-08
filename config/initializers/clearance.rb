Clearance.configure do |config|
  config.mailer_sender = 'team@mailkiq.com'
  config.routes = false
  config.user_model = Account
end

Clearance::BaseController.layout 'clearance'
Clearance::PasswordsController.layout 'clearance'
Clearance::SessionsController.layout 'clearance'
Clearance::UsersController.layout 'clearance'
