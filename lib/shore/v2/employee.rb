# frozen_string_literal: true

require_relative 'client_base'

module Shore
  module V2
    # @see https://docs.shore.com/v2/#employee
    class Employee < ClientBase
      has_one :organization
      has_many :merchants

      # PATCH /v1/employees/:id/actions/confirm
      #   ?confirmation_token=:confirmation_token
      custom_endpoint 'actions/confirm_email',
                      on: :member, request_method: :patch
      # PATCH /v1/employees/:id/actions/resend
      custom_endpoint 'actions/resend_confirmation',
                      on: :member, request_method: :patch
    end
  end
end
