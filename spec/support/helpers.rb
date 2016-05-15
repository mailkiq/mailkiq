module Helpers
  def expect_sign_in_as(account)
    expect(Account).to receive(:find_by)
      .with(api_key: account.api_key)
      .and_return(account)
  end

  def fixture_file(filename)
    return '' if filename.blank?
    file_path = File.expand_path(Rails.root + 'spec/fixtures/' + filename)
    File.read(file_path)
  end

  def json(filename)
    JSON.parse fixture_file("#{filename}.json"), symbolize_names: true
  end
end

RSpec.configure do |config|
  config.include Helpers
end
