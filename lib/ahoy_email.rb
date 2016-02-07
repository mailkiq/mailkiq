require 'openssl'
require 'safely_block'
require 'addressable/uri'
require 'ahoy_email/processor'
require 'ahoy_email/interceptor'
require 'ahoy_email/mailer'

module AhoyEmail
  mattr_accessor :secret_token, :options, :subscribers

  self.options = {
    message: true,
    open: true,
    click: true,
    utm_params: true,
    utm_source: proc { |_message, mailer| mailer.mailer_name },
    utm_medium: 'email',
    utm_term: nil,
    utm_content: nil,
    utm_campaign: proc { |_message, mailer| mailer.action_name },
    user: proc { |message, _mailer| (message.to.size == 1 ? User.where(email: message.to.first).first : nil) rescue nil },
    mailer: proc { |message, mailer| "#{mailer.class.name}##{mailer.action_name}" },
    url_options: {}
  }

  self.subscribers = []

  def self.track(options)
    self.options = self.options.merge(options)
  end

  class << self
    attr_writer :message_model
  end

  def self.message_model
    @message_model || Ahoy::Message
  end
end

ActionMailer::Base.send :include, AhoyEmail::Mailer
ActionMailer::Base.register_interceptor AhoyEmail::Interceptor
