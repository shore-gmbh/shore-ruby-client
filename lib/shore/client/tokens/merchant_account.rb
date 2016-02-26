# frozen_string_literal: true
module Shore
  module Client
    module Tokens
      class MerchantAccount # :nodoc:
        require_relative 'merchant_role'

        TYPE = 'merchant-accounts'

        attr_accessor :id
        attr_accessor :name
        attr_accessor :roles
        attr_reader :type

        # @example data
        #   {
        #     "id": "226fc766-3cf0-4d18-a988-5f8235f17edb",
        #     "type": "merchant-accounts",
        #     "attributes": {
        #       "name": "Bob Barker",
        #       "roles": [
        #         {
        #           "id": "74eb402b-e159-4027-9363-60772e6e8930",
        #           "type": "merchants",
        #           "slug": "achsel-alex",
        #           "name": "Achsel Alex",
        #           "role": "member"
        #         }
        #       ]
        #     }
        #   }
        # @param data [Hash]
        # @see #as_json
        def self.parse(data)
          type = data.try(:[], 'type')
          fail "Incorrect type: '#{type}'" if type != TYPE
          attributes =
            data.slice('id').merge(data['attributes'].slice('name', 'roles'))
          new(attributes)
        end

        # @param attrs [Hash]
        # @option attrs [String] :id
        # @option attrs [String] :name
        # @option attrs [String] :roles
        def initialize(attrs = {})
          self.attributes = attrs
          @type = TYPE
          @roles ||= []
        end

        def attributes=(attributes = {})
          attributes.each_pair do |attr, value|
            if respond_to?(assign = "#{attr}=")
              public_send(assign, value)
            end
          end
        end

        def attributes
          Hash[%i(id type name roles).map do |attr_name|
            [attr_name, public_send(attr_name)]
          end]
        end

        def roles=(values)
          values = values.map { |value| parse_role(value) } if values.present?
          @roles = values
        end

        # @example json
        #   {
        #     "id": "226fc766-3cf0-4d18-a988-5f8235f17edb",
        #     "type": "merchant-accounts",
        #     "attributes": {
        #       "name": "Bob Barker",
        #       "roles": [
        #         {
        #           "id": "74eb402b-e159-4027-9363-60772e6e8930",
        #           "type": "merchants",
        #           "slug": "achsel-alex",
        #           "name": "Achsel Alex",
        #           "role": "member"
        #         }
        #       ]
        #     }
        #   }
        # @param data [Hash]
        # @see parse
        def as_json
          attrs = attributes
          json_attributes =
            attrs.slice(:name).merge(roles: roles.map(&:attributes))
          attrs.slice(:id, :type).merge(attributes: json_attributes)
        end

        private

        def parse_role(value)
          if (type = value.try(:[], 'type')).present?
            fail "Unkown role type: '#{type}'" unless
              type == Shore::Client::Tokens::MerchantRole::TYPE

            value = Shore::Client::Tokens::MerchantRole.new(value)
          end
          value
        end
      end
    end
  end
end
