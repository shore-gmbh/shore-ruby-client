# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shore/version'

Gem::Specification.new do |spec|
  spec.name          = 'shore'
  spec.version       = Shore::VERSION
  spec.authors       = ['Austin Moore', 'Konstantin Delchev']
  spec.email         = %w[it@shore.com]

  spec.summary       = 'Shore Ruby Client'
  spec.description   = 'Ruby client gem for the Shore APIs.'
  spec.homepage      = 'https://github.com/shore-gmbh/shore-ruby-client'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    # TODO: Set to 'http://mygemserver.com'
    spec.metadata['allowed_push_host'] = ''
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem\
pushes.'
  end

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6.0'
  spec.add_runtime_dependency 'activesupport', '>= 6'
  spec.add_runtime_dependency 'concurrent-ruby', '1.3.4'

  # Clients for http://jsonapi.org/ compatible API's can mostly be generated
  # at runtime.
  # Note: this library is undergoing active development. Please update often!
  # https://github.com/chingor13/json_api_client
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'coveralls', '~> 0.8.23'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.93.1'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'timecop', '~> 0.9'
  spec.add_development_dependency 'webmock', '~> 3.7'
  spec.add_runtime_dependency 'dotenv', '>= 2'
  spec.add_runtime_dependency 'json_api_client', '~> 1.23.0'
end
