require_relative 'payment_base'

module Shore
  module V1
    # TODO@am: Add `@see` link to public api documentation
    # TODO@am: Use base class `ClientBase` as soon as requestable via gateway
    class Charge < PaymentBase
    end
  end
end
