require_relative 'client_base'

module Shore
  # @see https://docs.shore.com/v1/#employees
  class Employee < ClientBase
    has_one :organization

    # PATCH /v1/employees/:id/confirm?confirmation_token=:confirmation_token
    custom_endpoint :confirm, on: :member, request_method: :patch
    # PATCH /v1/employees/:id/resend
    custom_endpoint :confirm, on: :member, request_method: :patch
  end
end
