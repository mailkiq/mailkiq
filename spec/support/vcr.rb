VCR.configure do |config|
  config.default_cassette_options = { record: :once, allow_playback_repeats: true }
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end
