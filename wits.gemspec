# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wits/version'

Gem::Specification.new do |spec|
  spec.name          = 'wits'
  spec.version       = Wits::VERSION
  spec.authors       = ['Gordon Chan']
  spec.email         = ["developer.gordon+github@gmail.com"]

  spec.summary       = 'Retrieves electricity data from WITS Free to Air'
  spec.description   = 'A Ruby interface for WITS (Wholesale and
    information trading system) to retrieve New Zealand electricity data.'
  spec.homepage      = 'https://www.github.com/gchan/wits'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb'] + %w(CHANGELOG.md LICENSE.txt README.md wits.gemspec)
  spec.bindir        = 'bin'
  spec.require_paths = ['lib']
  spec.platform      = Gem::Platform::RUBY

  spec.add_runtime_dependency 'faraday', '~> 0.9.1'
  spec.add_runtime_dependency 'tzinfo', '~> 1.2.2'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry', '~> 0.10.1'

  spec.add_development_dependency 'guard-rspec', '~> 4.7.3'
  spec.add_development_dependency 'rspec', '~> 3.5.0'
  spec.add_development_dependency 'vcr', '~> 3.0.3'
  spec.add_development_dependency 'webmock', '~> 2.3.2'
  spec.add_development_dependency 'multi_json', '~> 1.12.1'
  spec.add_development_dependency 'timecop', '~> 0.8.1'
  spec.add_development_dependency 'simplecov', '~> 0.12.0'
  spec.add_development_dependency 'rubocop', '~> 0.47.1'
  spec.add_development_dependency 'coveralls', '~> 0.8.19'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0.5'
  spec.add_development_dependency 'tins', '~> 1.13.2'
  spec.add_development_dependency 'listen', '~> 3.1.5'
end
