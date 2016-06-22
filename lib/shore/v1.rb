require 'active_support/all'
Dotenv.load if defined? Dotenv
require_relative 'version'
require_relative 'authorization'
require_relative 'v1/all'

# Only after all of the clients have been registered, create the factory for
# this version.
require_relative 'v1/client_factory'

module Shore
  module V1 # :nodoc:
    # Shorten the code by adding all of the V1 classes/modules also directly
    # under the Shore module.
    constants.map { |name| [name, const_get(name)] }
      .each do |name, klass|
      # This is the same as `Shore::Merchant = Shore::V1::Merchant`
      Shore.const_set(name, klass)
    end
  end
end

# TODO@am: Move this to a server-side gem. It doesn't belong here in the client.
require 'shore/tokens/access_token'
