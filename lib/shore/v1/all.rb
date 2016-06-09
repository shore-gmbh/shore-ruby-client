# Require all of the client classes for each micro-service.
require_relative 'client_base'

# Core
require_relative 'appointment'
require_relative 'merchant'
require_relative 'merchant_account'
require_relative 'resource'
require_relative 'service'

# Customer Service
require_relative 'customer'

# Messaging Service
require_relative 'conversation'
require_relative 'message'
require_relative 'participant'

# Newsletter Service
require_relative 'newsletter'

module Shore
  module V1 # :nodoc:
    # Shorten the code by adding all of the client classes to the Shore
    # module (e.g. `Shore::Merchant = Shore::V1::Merchant`).
    constants.map { |name| [name, const_get(name)] }
      .select { |_name, klass| Class.equal?(klass) }
      .each do |name, klass|
      Shore.const_set(name, klass)
    end
  end
end
