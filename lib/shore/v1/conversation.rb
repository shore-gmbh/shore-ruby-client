<<<<<<< HEAD
=======
require_relative 'client_base'

>>>>>>> 7e51502... Merge pull request #25 in SHORE/shore-ruby-client from feature/XDC-458-implement-support-for-v2-on-shore-ruby-client to master
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
