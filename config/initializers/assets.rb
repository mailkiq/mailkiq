Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.paths <<
  Rails.root.join('vendor', 'assets', 'bower')

Rails.application.config.assets.paths <<
  Rails.root.join('vendor', 'assets', 'bower', 'bootstrap-sass', 'assets', 'fonts')
