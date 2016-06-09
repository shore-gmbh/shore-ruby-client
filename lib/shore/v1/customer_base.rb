require_relative 'client_base'

module Shore
  module V1
    # @abstract
    class CustomerBase < ClientBase
      self.site = url_for(:customer, :v1)
    end
  end
end
