require_relative 'newsletter_base'

module Shore
  module V1
    # TODO@am: Use base class `ClientBase` as soon as requestable via gateway
    # @see https://docs.shore.com/v1/#newsletters
    class Newsletter < NewsletterBase
    end
  end
end
