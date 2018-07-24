# frozen_string_literal: true

require_relative 'client_base'

module Shore
  module V2
    # @see https://docs.shore.com/v2/#customers
    class Customer < ClientBase
      custom_endpoint 'actions/unsubscribe',
                      on: :member, request_method: :post

      custom_endpoint 'actions/request_double_optin',
                      on: :collection, request_method: :post
    end
  end
end
