# frozen_string_literal: true

require_relative 'client_base'

module Shore
  module V2
    # @see https://docs.shore.com/v2/#services
    class Service < ClientBase
      has_one :merchant
    end
  end
end
