require 'json_api_client'
require 'shore/json_api_client'

module Shore
  # Base class for all Shore client resource classes.
  # @abstract
  class ClientBase < JsonApiClient::Resource
    include Shore::JsonApiClientExt::ComparableByTypeAndId
    include Shore::JsonApiClientExt::WithUrl
    include Shore::JsonApiClientExt::VersionableApi

    self.site = base_url(:v1)

    connection do |connection|
      connection.use Shore::JsonApiClientExt::AuthorizationMiddleware
    end
  end
end
