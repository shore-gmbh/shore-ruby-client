require_relative 'client_base'

module Shore
  module V1
    # @see https://docs.shore.com/v1/#conversations
    class Conversation < ClientBase
      has_one :merchant
      has_one :last_message
      has_many :participants

      property :created_at, type: :time
      property :updated_at, type: :time
    end
  end
end
