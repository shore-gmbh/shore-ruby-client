require_relative 'payment_base'

module Shore
  module V1
    # TODO@am: Use base class `ClientBase` as soon as requestable via gateway
    # @see https://docs.shore.com/v1/#stripepayments
    class StripePayment < PaymentBase
    end
  end
end
