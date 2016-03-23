module Shore
  module Client
    class NoServiceEnvironmentVariable < StandardError; end
    class Services
      def self.url_for(service, version)
        service_env = service.to_s.upcase + '_BASE_URI'
        base_uri = ENV[service_env]
        base_uri ||= default_uri(service)

        if base_uri.nil? || base_uri == ""
          raise NoServiceEnvironmentVariable, "#{service_env} ENV var " \
            "was not defined for #{service.to_s} version #{version.to_s}"
        end

        uri = URI(base_uri)
        uri.path = "/#{version.to_s}"
        uri.to_s
      end

      def self.default_uri(service)
        case service
        when :messaging
          'https://messaging.shore.com'
        when :newsletter
          'https://newsletter.shore.com'
        end
      end

      private_class_method :default_uri
    end
  end
end

