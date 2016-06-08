module Shore
  module Client
    module V1
      class Message < MessagingBase # :nodoc:
        has_one :conversation
        has_one :sender

        property :created_at, type: :time
      end
    end
  end
end
