require 'active_support/all'

require_relative 'version'
require_relative 'authorization'
require_relative 'v1/all'
require_relative 'client_factory'

# TODO@am: Move this to a server-side gem. It doesn't belong here in the client.
require 'shore/tokens/access_token'
