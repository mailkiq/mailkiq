VCR.configure do |config|
  config.configure_rspec_metadata!
  config.hook_into :webmock
  config.cassette_library_dir = 'spec/vcr'
  config.default_cassette_options =
    { record: :once, allow_playback_repeats: true }
end
