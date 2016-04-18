Devise.setup do |config|
  require 'devise/orm/active_record'

  config.mailer_sender = 'team@mailkiq.com'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = false
  config.remember_for = 2.weeks
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..72
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
end
