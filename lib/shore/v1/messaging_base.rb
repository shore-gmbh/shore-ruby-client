require_relative 'client_base'

module Shore
  module V1
    # @abstract
    # @deprecated As soon as all micro-services are callable via the shore
    #   api gateway, then this will no longer be needed.
    class MessagingBase < ClientBase
      self.site = url_for(:messaging, :v1)
    end
  end
end
