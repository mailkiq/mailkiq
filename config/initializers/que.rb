require 'mail'

if $PROGRAM_NAME.end_with?('que')
  Aws.eager_autoload! services: %w(SES SQS)
  Mail.eager_autoload!
  Rails.application.eager_load!
end
