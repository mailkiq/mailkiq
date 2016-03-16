Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass
  config.assets.compile = false
  config.assets.digest = true
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  config.log_level = :debug
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
  config.action_mailer.default_url_options = { host: 'mailkiq.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV['SMTP_ADDRESS'],
    port: 587,
    domain: 'mailkiq.com',
    user_name: ENV['SMTP_USER_NAME'],
    password: ENV['SMTP_PASSWORD'],
    authentication: :login,
    enable_starttls_auto: true
  }
end
