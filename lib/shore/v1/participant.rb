<<<<<<< HEAD
=======
require_relative 'client_base'

>>>>>>> 7e51502... Merge pull request #25 in SHORE/shore-ruby-client from feature/XDC-458-implement-support-for-v2-on-shore-ruby-client to master
module Shore
  module V1
    # @see https://docs.shore.com/v1/#participants
    class Participant < ClientBase
      has_one :group
      has_many :senders

      property :added_at, type: :time
    end
  end
end
