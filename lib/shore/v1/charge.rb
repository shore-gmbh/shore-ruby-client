require_relative 'payment_base'

module Shore
  module V1
    # TODO@am: Use base class `ClientBase` as soon as requestable via gateway
    # @see https://docs.shore.com/v1/#charges
    class Charge < PaymentBase
    end
  end
end
