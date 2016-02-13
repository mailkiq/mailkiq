require 'openssl'

module Signature
  module_function

  def secret_key_base
    @secret_key_base ||= Rails.application.secrets.secret_key_base
  end

  def hexdigest(string)
    OpenSSL::HMAC.hexdigest OpenSSL::Digest.new('sha1'), secret_key_base, string
  end

  def secure_compare(a, b)
    ActiveSupport::SecurityUtils.secure_compare(a, b)
  end
end
