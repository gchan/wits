require 'simplecov'
require 'coveralls'
require 'codeclimate-test-reporter'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter,
  CodeClimate::TestReporter::Formatter
]

# No JRuby support for SimpleCov
# https://github.com/metricfu/metric_fu/commit/2248706
unless defined?(JRUBY_VERSION)
  SimpleCov.start do
    add_filter '/spec/'
    # Travis configures bundler to install dependencies in vendor
    # https://github.com/colszowka/simplecov/issues/360
    add_filter '/vendor/'
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'wits'
require 'pry'
require 'vcr'
require 'timecop'
require 'support/request_helpers'
require 'support/time_parser'

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.default_cassette_options = { serialize_with: :json }
  config.configure_rspec_metadata!

  config.ignore_hosts 'codeclimate.com'
end

RSpec.configure do |config|
  config.include RequestHelpers
  config.include TimeParser
end
