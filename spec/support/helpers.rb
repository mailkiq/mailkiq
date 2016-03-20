module Helpers
  module API
    def set_content_type_header!
      @request.headers['Content-Type'] = JSONAPI::MEDIA_TYPE
    end

    def api_sign_in(account)
      expect(Account).to receive(:find_by)
        .with(api_key: account.api_key)
        .and_return(account)
    end

    def fixture(path)
      JSON.parse File.read("spec/vcr/#{path}.json")
    end
  end
end

RSpec.configure do |config|
  config.include Helpers::API, :api
end
