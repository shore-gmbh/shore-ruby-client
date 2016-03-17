module Shore
  module Client
    module Messaging
      module V1
        class Base < JsonApiClient::Resource # :nodoc:
          self.site = Shore::Client::Messaging.base_uri(:v1)
        end
      end
    end
  end
end

class ShoreClientMiddleware < Faraday::Middleware # :nodoc:
  def call(env)
    if (authorization = Shore::Client.authorization)
      env[:request_headers]['Authorization'] = authorization
    end
    @app.call(env)
  end
end

Shore::Client::Messaging::V1::Base.connection do |connection|
  connection.use ShoreClientMiddleware
end
