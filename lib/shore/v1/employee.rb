require_relative 'client_base'

module Shore
  module V1
    # @see https://docs.shore.com/v1/#employees
    class Employee < ClientBase
      has_one :organization

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
