APP_ENV = ENV['RAILS_ENV'] || ENV['RACK_ENV']

require 'active_support/all'

require 'dotenv'
Dotenv.load(
  File.expand_path("../.env.#{APP_ENV}", __FILE__),
  File.expand_path('../.env', __FILE__)
)

require_relative 'shore/version'
require_relative 'shore/authorization'

require_relative 'shore/versions_manager'

Shore::VersionsManager.instance.load_version(:v1)
Shore::VersionsManager.instance.load_version(:v2)

Shore::VersionsManager.instance.set_default_api_version(:v1)

# Only after all of the clients have been registered, create the factory for
# this version.
require_relative 'shore/client_factory'

# TODO@am: Move this to a server-side gem. It doesn't belong here in the client.
require 'shore/tokens/access_token'
