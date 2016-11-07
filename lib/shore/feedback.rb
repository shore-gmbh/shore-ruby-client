require_relative 'client_base'

module Shore
  # @see https://docs.shore.com/v1/#feedbacks
  class Feedback < ClientBase
    has_one :merchant
    has_one :customer
    has_one :appointment
  end
end
