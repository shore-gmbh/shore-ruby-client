require_relative 'client_base'

module Shore
  # @see https://docs.shore.com/v1/#messages
  class Message < ClientBase
    has_one :conversation
    has_one :sender

    property :created_at, type: :time

    # PATCH /messages/:id/read
    custom_endpoint :read, on: :member, request_method: :patch
  end
end
