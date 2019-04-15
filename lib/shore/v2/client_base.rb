# frozen_string_literal: true

require 'json_api_client'
require 'shore/json_api_client'
require 'shore/custom/paginator'

module Shore
  module V2
    # Base class for all Shore client resource classes.
    # @abstract
    class ClientBase < JsonApiClient::Resource
      include Shore::JsonApiClientExt::BuildRelationships
      include Shore::JsonApiClientExt::ComparableByTypeAndId
      include Shore::JsonApiClientExt::CustomEndpoints
      include Shore::JsonApiClientExt::VersionableApi
      include Shore::JsonApiClientExt::WithMeta
      include Shore::JsonApiClientExt::WithUrl

      self.site = base_url(:v2)
      self.paginator = Shore::Custom::Paginator

      connection do |connection|
        connection.use Shore::JsonApiClientExt::AuthorizationMiddleware
      end
    end
  end
end
