# frozen_string_literal: true

module Shore # :nodoc:
  module_function

  def with_authorization(authorization)
    initial_value = self.authorization
    self.authorization = authorization
    yield
  ensure
    self.authorization = initial_value
  end

  # @see with_authorization
  def authorization=(value)
    Thread.current[:shore_client_current_authorization] = value
  end

  def authorization
    Thread.current[:shore_client_current_authorization]
  end
end
