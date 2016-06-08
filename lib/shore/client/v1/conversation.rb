module Shore
  module Client
    module V1
      class Conversation < MessagingBase # :nodoc:
        has_one :merchant
        has_one :last_message
        has_many :participants

        property :created_at, type: :time
        property :updated_at, type: :time
      end
    end
  end
end
