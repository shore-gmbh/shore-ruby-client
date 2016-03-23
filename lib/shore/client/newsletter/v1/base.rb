module Shore
  module Client
    module Newsletter
      module V1
        class Base < JsonApiClient::Resource # :nodoc:
          self.site = Shore::Client::Services.url_for(:newsletter, :v1)
        end
      end
    end
  end
end

Shore::Client::Newsletter::V1::Base.connection do |connection|
  connection.use ShoreClientMiddleware
end
