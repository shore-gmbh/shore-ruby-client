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
    if (token = Shore::Client.access_token)
      env[:request_headers]['Authorization'] = "Bearer #{token}"
    end
    @app.call(env)
  end
end

Shore::Client::Messaging::V1::Base.connection do |connection|
  connection.use ShoreClientMiddleware
end
