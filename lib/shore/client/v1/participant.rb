module Shore
  module Client
    module V1
      class Participant < MessagingBase # :nodoc:
        has_one :group
        has_many :senders

        property :added_at, type: :time
      end
    end
  end
end
