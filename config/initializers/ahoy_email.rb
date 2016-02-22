require 'addressable/uri'
require 'ahoy_email'
require 'ahoy_email/processor'
require 'ahoy_email/interceptor'
require 'ahoy_email/mailer'

ActionMailer::Base.send :include, AhoyEmail::Mailer
ActionMailer::Base.register_interceptor AhoyEmail::Interceptor
