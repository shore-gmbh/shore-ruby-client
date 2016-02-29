# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shore/client/version'

Gem::Specification.new do |spec|
  spec.name          = 'shore-client'
  spec.version       = Shore::Client::VERSION
  spec.authors       = ['Konstantin Delchev']
  spec.email         = %w(konstantin.delchev@shore.com tech@shore.com)

  spec.summary       = 'Shore Ruby Client'
  spec.description   = 'Ruby client gem that provides access to Shore APIs'
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

  spec.add_runtime_dependency 'jwt', '~> 1.5.3'
  spec.add_runtime_dependency 'activesupport', '>= 3'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4.0'
  spec.add_development_dependency 'overcommit', '~> 0.29.1'
  spec.add_development_dependency 'rubocop', '~> 0.35.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.3.0'
  spec.add_development_dependency 'simplecov', '~> 0.11.1'
  spec.add_development_dependency 'timecop'
end
