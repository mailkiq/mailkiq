require File.expand_path('../application', __FILE__)
Rails.application.initialize!
Rails.application.eager_load! if $PROGRAM_NAME.end_with?('que')
