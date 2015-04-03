# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wits/version'

Gem::Specification.new do |spec|
  spec.name          = 'wits'
  spec.version       = Wits::VERSION
  spec.authors       = ['Gordon Chan']
  spec.email         = ['developer.gordon@gmail.com']

  spec.summary       = %q{Retrieves electricity data from WITS Free to Air}
  spec.description   = %q{This client library interfaces with WITS (Wholesale and
    information trading system) to fetch New Zealand electricity data, preparing it
    to be consumed by Ruby code.}
  spec.homepage      = 'https://www.github.com/gchan/wits'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = 'bin'
  spec.require_paths = ['lib']
  spec.platform      = Gem::Platform::RUBY

  spec.add_runtime_dependency 'faraday', '~> 0.9.1'
  spec.add_runtime_dependency 'tzinfo', '~> 1.2.2'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry', '~> 0.10.1'

  spec.add_development_dependency 'guard-rspec', '~> 4.5.0'
  spec.add_development_dependency 'rspec', '~> 3.2.0'
  spec.add_development_dependency 'vcr', '~> 2.9.3'
  spec.add_development_dependency 'webmock', '~> 1.20.4'
  spec.add_development_dependency 'multi_json', '~> 1.11.0'
  spec.add_development_dependency 'timecop', '~> 0.7.3'
  spec.add_development_dependency 'simplecov', '~> 0.9.2'
  spec.add_development_dependency 'rubocop', '~> 0.29.1'
end
