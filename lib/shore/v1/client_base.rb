require 'json_api_client'

require 'shore/json_api_client/authorization_middleware'
require 'shore/json_api_client/comparable_by_type_and_id'
require 'shore/json_api_client/with_url'
require 'shore/json_api_client/versionable_api'

module Shore
  module V1
    # Base class for all Shore client resource classes.
    # @abstract
    class ClientBase < ::JsonApiClient::Resource
      include Shore::JsonApiClient::ComparableByTypeAndId
      include Shore::JsonApiClient::WithUrl
      include Shore::JsonApiClient::VersionableApi

      self.site = base_url(:v1)

      connection do |connection|
        connection.use Shore::JsonApiClient::AuthorizationMiddleware
      end
    end
  end
end
