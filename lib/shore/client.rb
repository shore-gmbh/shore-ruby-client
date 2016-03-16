require 'active_support/all'
require_relative 'client/version'
require_relative 'client/tokens/access_token'
require_relative 'client/messaging'

module Shore
  module Client # :nodoc:
    def with_access_token(access_token)
      self.access_token = access_token
      yield
    ensure
      self.access_token = nil
    end
    module_function :with_access_token

    def access_token=(value)
      Thread.current[:shore_client_current_access_token] = value
    end
    module_function :access_token=

    def access_token
      Thread.current[:shore_client_current_access_token]
    end
    module_function :access_token
  end
end
