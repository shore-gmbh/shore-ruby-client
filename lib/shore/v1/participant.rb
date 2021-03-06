# frozen_string_literal: true

require_relative 'client_base'

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
