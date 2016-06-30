require_relative 'messaging_base'

module Shore
  module V1
    # TODO@am: Add `@see` link to public api documentation
    # TODO@am: Use base class `ClientBase` as soon as requestable via gateway
    class Message < MessagingBase
      has_one :conversation
      has_one :sender

      property :created_at, type: :time

      # PATCH /messages/:id/read
      custom_endpoint :read, on: :member, request_method: :patch
    end
  end
end
