module Devise
  module Test
    module IntegrationHelpers
      def stub_sign_in(resource)
        allow(resource).to receive(:save)
        sign_in resource
      end
    end
  end
end

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::IntegrationHelpers, type: :request
end
