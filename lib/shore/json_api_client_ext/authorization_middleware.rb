require 'faraday'
require 'shore/authorization'

module Shore
  module JsonApiClientExt
    # Set the "Authorization" header for all requests.
    # @see Shore.authorization
    class AuthorizationMiddleware < Faraday::Middleware
      def call(env)
        if (authorization = Shore.authorization)
          env[:request_headers]['Authorization'] = authorization
        end
        @app.call(env)
      end
    end
  end
end
