RSpec::Matchers.define :have_scope do |expected|
  chain :use do |*args|
    @subkeys = args
  end

  match do |actual|
    if actual.is_a? ActionController::Base
      scope = actual.scopes_configuration[expected]
    elsif actual.is_a? Hash
      scope = actual[expected]
    else
      fail 'expected controller or hash as argument'
    end

    scope.present? && scope[:using] == @subkeys
  end
end
