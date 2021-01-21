# frozen_string_literal: true

module Shore
  # @example Constants
  #   class MyClass
  #     include Shore::ClientFactory
  #   end
  #   MyClass::APPOINTMENTS # => 'appointments'
  #
  # Build instances of Shore ruby clients.
  #
  # Defines constant for each resource type.
  module ClientFactory
    extend ActiveSupport::Concern

    # Add all of the client classes to a hash keyed to their type
    # (a.k.a. table_name).
    parent_module = respond_to?(:module_parent) ? module_parent : parent
    CLIENT_TYPES = Hash[
      parent_module.constants.map { |name| parent_module.const_get(name) }
            .select { |klass| klass.respond_to?(:table_name) }
            .map { |klass| [klass.table_name, klass] }
    ].freeze
    private_constant :CLIENT_TYPES

    included do
      # Create a constant for each resource type (e.g.
      # APPOINTMENTS # => 'appointments').
      CLIENT_TYPES.each_key do |type|
        const_set(type.upcase, type.freeze)
      end
    end

    # @params type [String] valid json:api type
    # @returns [Class] client class for the given type
    # @raises [ArgumentError] if type doesn't map to any known client class
    def client_class(type, version: default_shore_api_version)
      Shore::VersionsManager.instance.class_for(type: type, version: version)
    end

    # @note This method DOES NOT make any network requests. The initialized
    #   clients DO NOT have any attributes or relationships. They only
    #   have an {#id} and {#type}
    #
    # Initializes an instance of the client.
    #
    # @params type [String] valid client {#type}
    # @params id [String] valid client {#id}
    # @returns [Object] instance with the given {#id} and {#type}
    # @raises [ArgumentError] if type doesn't map to any known client class
    def client(type:, id:)
      client_class(type).new(id: id)
    end

    def default_shore_api_version
      Shore::VersionsManager.instance.default_version
    end
  end
end
