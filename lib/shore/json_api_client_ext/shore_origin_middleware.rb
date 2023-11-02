
# frozen_string_literal: true

require 'faraday'
require 'shore/authorization'

module Shore
  module JsonApiClientExt
    # Set the "Authorization" header for all requests.
    # @see Shore.authorization
    class ShoreOriginMiddleware < Faraday::Middleware
      def call(env)
        env[:request_headers]['X-Shore-Origin'] = ENV['DD_APP_NAME']

        @app.call(env)
      end
    end
  end
end
