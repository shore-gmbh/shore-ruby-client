# frozen_string_literal: true

require_relative 'client_base'

module Shore
  module V1
    # @see https://docs.shore.com/v1/#customers
    class Customer < ClientBase
      custom_endpoint 'actions/unsubscribe',
                      on: :member, request_method: :post
    end
  end
end
