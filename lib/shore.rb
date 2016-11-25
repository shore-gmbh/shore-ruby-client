<<<<<<< HEAD
fail "You must require a specific API version (e.g. `require 'shore/v1'`)"
=======
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


>>>>>>> 7e51502... Merge pull request #25 in SHORE/shore-ruby-client from feature/XDC-458-implement-support-for-v2-on-shore-ruby-client to master
