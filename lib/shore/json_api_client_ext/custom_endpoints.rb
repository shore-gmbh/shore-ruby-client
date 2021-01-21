# frozen_string_literal: true

module Shore
  module JsonApiClientExt
    # Adds {url} method to the class.
    module CustomEndpoints
      extend ActiveSupport::Concern

      module ClassMethods # :nodoc:
        protected

        # @param [String] :name the name of the endpoint. The name is the
        #   method name and the path to append for the request. If the name
        #   contains a '/' then the method name is only the last part of the
        #   path (e.g. 'one/two/three' => 'three')
        # @option [Symbol] :name The method name for this endpoint. Defaults to
        #   the `name` param.
        def custom_endpoint(name, options = {})
          options[:name] ||= name.to_s.split('/').last
          super
        end

        # @see .custom_endpoint
        # @see JsonApiClient::Resource.collection_endpoint
        def collection_endpoint(name, options = {})
          metaclass = class << self; self; end
          metaclass.instance_eval do
            define_method(options.fetch(:name)) do |*params|
              request_params = params.first || {}
              requestor.custom(name, options, request_params)
            end
          end
        end

        # @see .custom_endpoint
        # @see JsonApiClient::Resource.collection_endpoint
        def member_endpoint(name, options = {})
          define_method options.fetch(:name) do |*params|
            request_params = params.first || {}
            request_params[self.class.primary_key] =
              attributes.fetch(self.class.primary_key)
            self.class.requestor.custom(name, options, request_params)
          end
        end
      end
    end
  end
end
