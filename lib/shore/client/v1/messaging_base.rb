require 'shore/client/connection_middleware'

module Shore
  module Client
    module V1
      # @abstract
      class MessagingBase < JsonApiClient::Resource
        include ComparableByTypeAndId
        include WithUrl
        self.site = Shore::Client::Services.url_for(:messaging, :v1)
        connection do |connection|
          connection.use Shore::Client::ConnectionMiddleware
        end
      end
    end
  end
end
