require 'shore/client/connection_middleware'

module Shore
  module Client
    module V1
      # @abstract
      class CoreBase < JsonApiClient::Resource
        self.site = Shore::Client::Services.url_for(:core, :v1)
        connection do |connection|
          connection.use Shore::Client::ConnectionMiddleware
        end
      end
    end
  end
end
