require_relative 'messaging_base'

module Shore
  module V1
    # TODO@am: Add `@see` link to public api documentation
    # TODO@am: Use base class `ClientBase` as soon as requestable via gateway
    class Participant < MessagingBase
      has_one :group
      has_many :senders

      property :added_at, type: :time
    end
  end
end
