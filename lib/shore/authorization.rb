# frozen_string_literal: true

module Shore # :nodoc:
  module_function

  def with_authorization(authorization)
    self.authorization = authorization
    yield
  ensure
    self.authorization = nil
  end

  # @see with_authorization
  def authorization=(value)
    Thread.current[:shore_client_current_authorization] = value
  end

  def authorization
    Thread.current[:shore_client_current_authorization]
  end
end
