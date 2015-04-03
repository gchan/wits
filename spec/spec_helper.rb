require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'wits'
require 'vcr'
require 'timecop'
require 'support/request_helpers'
require 'support/time_parser'

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.default_cassette_options = { serialize_with: :json }
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.include RequestHelpers
  config.include TimeParser
end
