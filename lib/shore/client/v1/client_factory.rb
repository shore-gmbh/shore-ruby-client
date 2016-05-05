module Shore
  module Client
    module V1
      # @example Constants
      #   class MyClass
      #     include Shore::Client::V1::ClientFactory
      #   end
      #   MyClass::APPOINTMENTS # => 'appointments'
      #
      # Build instances of Shore ruby client resources.
      #
      # Defines constant for each resource type.
      module ClientFactory
        extend ActiveSupport::Concern

        CLIENT_TYPES = Hash[
          [Shore::Client::V1::Appointment,
           Shore::Client::V1::Conversation,
           Shore::Client::V1::Customer,
           Shore::Client::V1::Merchant,
           Shore::Client::V1::MerchantAccount,
           Shore::Client::V1::Message,
           Shore::Client::V1::Newsletter,
           Shore::Client::V1::Participant].map do |klass|
            [klass.table_name, klass]
          end].freeze
        private_constant :CLIENT_TYPES

        included do
          # Create a constant for each resource type (e.g.
          # APPOINTMENTS # => 'appointments').
          CLIENT_TYPES.keys.each do |type|
            const_set(type.upcase, type.freeze)
          end
        end

        # @params type [String] valid resource {JsonApiClient::Resource#type}
        # @returns [Class] resource class for the given type
        # @raises [ArgumentError] if type doesn't map to any known resource
        #   class
        def client_class(type)
          if (klass = CLIENT_TYPES[type.to_s])
            return klass
          end

          fail ArgumentError, "[Shore] Error: Unknown client type: '#{type}'"
        end

        # @note This method DOES NOT make any network requests. The initialized
        #   resources DO NOT have any attributes or relationships. They only
        #   have an {JsonApiClient::Resource#id} and
        #   {JsonApiClient::Resource#type}
        #
        # Initializes an instance of the resource.
        #
        # @params type [String] valid resource {JsonApiClient::Resource#type}
        # @params id [String] valid resource {JsonApiClient::Resource#id}
        # @returns [JsonApiClient::Resource] instance with the given id and type
        # @raises [ArgumentError] if type doesn't map to any known resource
        #   class
        def client(type:, id:)
          client_class(type).new(id: id)
        end
      end
    end
  end
end
