require 'json_api_client'
require_relative 'bulk_finder'
JsonApiClient::Query::Builder.include(Shore::Client::BulkFinder)
require_relative 'v1/core_base'
require_relative 'v1/messaging_base'
require_relative 'v1/newsletter_base'
require_relative 'v1/customer_base'
require_relative 'v1/conversation'
require_relative 'v1/message'
require_relative 'v1/participant'
require_relative 'v1/merchant'
require_relative 'v1/merchant_account'
require_relative 'v1/appointment'
require_relative 'v1/customer'
require_relative 'v1/newsletter'
require_relative 'v1/client_factory'
