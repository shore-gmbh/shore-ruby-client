# frozen_string_literal: true

require 'shore/json_api_client_ext/authorization_middleware'
require 'shore/json_api_client_ext/build_relationships'
require 'shore/json_api_client_ext/bulk_finder'
require 'shore/json_api_client_ext/comparable_by_type_and_id'
require 'shore/json_api_client_ext/custom_endpoints'
require 'shore/json_api_client_ext/versionable_api'
require 'shore/json_api_client_ext/with_url'

# Add the bulk finder methods (e.g. `find_each`) to all JsonApiClient::Resource
# instances via the JsonApiClient::Query::Builder.
JsonApiClient::Query::Builder.include(Shore::JsonApiClientExt::BulkFinder)
