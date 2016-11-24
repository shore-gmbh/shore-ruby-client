require 'json_api_client'
require 'shore/json_api_client'

module Shore
  module V2
    # Base class for all Shore client resource classes.
    # @abstract
    class ClientBase < JsonApiClient::Resource
      include Shore::JsonApiClientExt::ComparableByTypeAndId
      include Shore::JsonApiClientExt::WithUrl
      include Shore::JsonApiClientExt::VersionableApi

      self.site = base_url(:v2)

      connection do |connection|
        connection.use Shore::JsonApiClientExt::AuthorizationMiddleware
      end
    end
  end
end
