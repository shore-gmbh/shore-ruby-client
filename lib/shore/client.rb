require 'active_support/all'
require_relative 'client/version'
require_relative 'client/services'
require_relative 'client/tokens/access_token'
require_relative 'client/messaging/v1'
require_relative 'client/uuid_helpers'

module Shore
  module Client # :nodoc:
    def with_authorization(authorization)
      self.authorization = authorization
      yield
    ensure
      self.authorization = nil
    end
    module_function :with_authorization

    # @see with_authorization
    def authorization=(value)
      Thread.current[:shore_client_current_authorization] = value
    end
    module_function :authorization=

    def authorization
      Thread.current[:shore_client_current_authorization]
    end
    module_function :authorization
  end
end
