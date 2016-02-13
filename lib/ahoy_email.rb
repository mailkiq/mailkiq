require 'addressable/uri'
require 'ahoy_email/processor'
require 'ahoy_email/interceptor'
require 'ahoy_email/mailer'

module AhoyEmail
  mattr_accessor :options

  self.options = {
    message: true,
    open: true,
    click: true,
    url_options: {},
    utm_params: true,
    utm_source: proc { |_message, mailer| mailer.mailer_name },
    utm_medium: 'email',
    utm_term: nil,
    utm_content: nil,
    utm_campaign: proc { |_message, mailer| mailer.action_name },
    mailer: proc do |_message, mailer|
      "#{mailer.class.name}##{mailer.action_name}"
    end
  }

  def self.track(options)
    self.options = self.options.merge(options)
  end
end

ActionMailer::Base.send :include, AhoyEmail::Mailer
ActionMailer::Base.register_interceptor AhoyEmail::Interceptor
