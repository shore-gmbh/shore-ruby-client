module Shore
  module Client
    module Messaging
      module V1
        class Base < JsonApiClient::Resource # :nodoc:
          self.site = Shore::Client::Messaging.base_uri(:v1)
        end
      end
    end
  end
end
