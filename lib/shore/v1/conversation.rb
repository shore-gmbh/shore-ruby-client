require_relative 'messaging_base'

module Shore
  module V1
    # TODO@am: Use base class `ClientBase` as soon as requestable via gateway
    # @see https://docs.shore.com/v1/#conversations
    class Conversation < MessagingBase # :nodoc:
      has_one :merchant
      has_one :last_message
      has_many :participants

      property :created_at, type: :time
      property :updated_at, type: :time
    end
  end
end
