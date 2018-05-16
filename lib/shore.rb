# frozen_string_literal: true

APP_ENV = ENV['RAILS_ENV'] || ENV['RACK_ENV']

require 'active_support/all'

require 'dotenv'
Dotenv.load(
  File.expand_path("../.env.#{APP_ENV}", __FILE__),
  File.expand_path('.env', __dir__)
)

require_relative 'shore/version'
require_relative 'shore/authorization'

require_relative 'shore/versions_manager'

Shore::VersionsManager.instance.load_version(:v1)
Shore::VersionsManager.instance.load_version(:v2)

Shore::VersionsManager.instance.default_api_version = :v1

# Only after all of the clients have been registered, create the factory for
# this version.
require_relative 'shore/client_factory'
