require 'shore/client/connection_middleware'

module Shore
  module Client
    module V1
      # @abstract
      class CustomerBase < JsonApiClient::Resource
        include ComparableByTypeAndId
        self.site = Shore::Client::Services.url_for(:customer, :v1)
        connection do |connection|
          connection.use Shore::Client::ConnectionMiddleware
        end
      end
    end
  end
end
