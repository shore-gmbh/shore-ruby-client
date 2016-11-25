<<<<<<< HEAD
=======
require_relative 'client_base'

>>>>>>> 7e51502... Merge pull request #25 in SHORE/shore-ruby-client from feature/XDC-458-implement-support-for-v2-on-shore-ruby-client to master
module Shore
  module V1
    # @see https://docs.shore.com/v1/#messages
    class Message < ClientBase
      has_one :conversation
      has_one :sender

      property :created_at, type: :time

      # PATCH /messages/:id/read
      custom_endpoint :read, on: :member, request_method: :patch
    end
  end
end
