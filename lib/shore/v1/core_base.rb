require_relative 'client_base'

module Shore
  module V1
    # @abstract
    class CoreBase < ClientBase
      self.site = url_for(:core, :v1)
    end
  end
end
