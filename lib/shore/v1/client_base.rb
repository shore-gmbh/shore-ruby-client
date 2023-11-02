# frozen_string_literal: true

require 'json_api_client'
require 'shore/json_api_client'

module Shore
  module V1
    # Base class for all Shore client resource classes.
    # @abstract
    class ClientBase < JsonApiClient::Resource
      include Shore::JsonApiClientExt::ComparableByTypeAndId
      include Shore::JsonApiClientExt::WithUrl
      include Shore::JsonApiClientExt::VersionableApi
      include Shore::JsonApiClientExt::CustomEndpoints
      include Shore::JsonApiClientExt::WithMeta

      self.site = base_url(:v1)

      connection do |connection|
        connection.use Shore::JsonApiClientExt::AuthorizationMiddleware
        connection.use Shore::JsonApiClientExt::ShoreOriginMiddleware
      end
    end
  end
end
