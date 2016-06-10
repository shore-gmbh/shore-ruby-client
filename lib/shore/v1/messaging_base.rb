require_relative 'client_base'

module Shore
  module V1
    # @abstract
    # @deprecated As soon as all micro-services are callable via the shore
    #   api gateway, then this will no longer be needed.
    class MessagingBase < JsonApiClient::Resource
      include Shore::JsonApiClientExt::ComparableByTypeAndId
      include Shore::JsonApiClientExt::WithUrl
      include Shore::JsonApiClientExt::VersionableApi

      self.site = url_for(:messaging, :v1)

      connection do |connection|
        connection.use Shore::JsonApiClientExt::AuthorizationMiddleware
      end
    end
  end
end
