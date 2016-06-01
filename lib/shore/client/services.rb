require 'uri'

module Shore
  module Client
    class NoServiceEnvironmentVariable < StandardError; end
    class Services # :nodoc:
      def self.url_for(service, version)
        service_env = service.to_s.upcase + '_BASE_URI'
        base_uri = ENV[service_env]
        base_uri ||= default_uri(service)

        if base_uri.nil? || base_uri == ''
          fail NoServiceEnvironmentVariable, "#{service_env} ENV var " \
            "was not defined for #{service} version #{version}"
        end

        uri = URI(base_uri)
        uri.path = "/#{version}"
        uri.to_s
      end

      def self.default_uri(service)
        case service
        when :messaging
          'https://shore-messaging-production.herokuapp.com'
        when :newsletter
          'https://newsletter.shore.com'
        when :core
          'https://secure.shore.com'
        when :customer
          'http://css.shore.com'
        end
      end

      private_class_method :default_uri
    end
  end
end
