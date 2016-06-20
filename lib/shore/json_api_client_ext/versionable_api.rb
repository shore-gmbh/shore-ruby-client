require 'uri'

module Shore
  module JsonApiClientExt
    # @deprecated As soon as all micro-services are callable via the shore
    #   api gateway, then this will no longer be needed.
    # @see base_url
    class NoServiceEnvironmentVariable < StandardError; end

    # @example
    #   class V5::MyBaseClass < JsonApiClient::Resource
    #     include Shore::Services
    #     self.site = base_url(:v5)
    module VersionableApi
      extend ActiveSupport::Concern

      DEFAULT_BASE_URI = 'https://api.shore.com'

      module ClassMethods # :nodoc:
        def base_url(version)
          base_uri = ENV['SHORE_API_BASE_URI']
          base_uri = DEFAULT_BASE_URI if base_uri.blank?

          uri = URI(base_uri)
          uri.path = "/#{version}"
          uri.to_s
        end

        # @deprecated As soon as all micro-services are callable via the shore
        #   api gateway, then this will no longer be needed.
        # @see base_url
        def url_for(service, version)
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

        private

        # @deprecated As soon as all micro-services are callable via the shore
        #   api gateway, then this will no longer be needed.
        # @see base_url
        def default_uri(service)
          case service
          when :messaging
            'https://shore-messaging-production.herokuapp.com'
          when :newsletter
            'https://newsletter.shore.com'
          when :core
            'https://secure.shore.com'
          when :customer
            'https://css.shore.com'
          when :communication
            'https://communication.shore.com'
          end
        end
      end
    end
  end
end
