# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shore/version'

Gem::Specification.new do |spec|
  spec.name          = 'shore'
  spec.version       = Shore::VERSION
  spec.authors       = ['Austin Moore', 'Konstantin Delchev']
  spec.email         = %w(it@shore.com)

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
    fail 'RubyGems 2.0 or newer is required to protect against public gem\
pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # TODO@am: Move shore/tokens to a server-side gem and remove this dependency.
  spec.add_runtime_dependency 'jwt', '~> 1'
  spec.add_runtime_dependency 'activesupport', '>= 3','< 5'
  # Clients for http://jsonapi.org/ compatible API's can mostly be generated
  # at runtime.
  # Note: this library is undergoing active development. Please update often!
  # https://github.com/chingor13/json_api_client
  spec.add_runtime_dependency 'json_api_client', '~> 1'
  spec.add_runtime_dependency 'dotenv', '>= 2'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4.0'
  spec.add_development_dependency 'overcommit', '~> 0.29.1'
  spec.add_development_dependency 'rubocop', '~> 0.35.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.3.0'
  spec.add_development_dependency 'simplecov', '~> 0.11.1'
  spec.add_development_dependency 'timecop', '~> 0.8'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'webmock', '~> 2.1'
end
