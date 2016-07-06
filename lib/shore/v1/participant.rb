require_relative 'messaging_base'

module Shore
  module V1
    # TODO@am: Use base class `ClientBase` as soon as requestable via gateway
    # @see https://docs.shore.com/v1/#participants
    class Participant < MessagingBase
      has_one :group
      has_many :senders

      property :added_at, type: :time
    end
  end
end
