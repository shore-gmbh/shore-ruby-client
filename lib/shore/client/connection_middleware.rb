module Shore
  module Client
    class ConnectionMiddleware < Faraday::Middleware # :nodoc:
      def call(env)
        if (authorization = Shore::Client.authorization)
          env[:request_headers]['Authorization'] = authorization
        end
        @app.call(env)
      end
    end
  end
end
