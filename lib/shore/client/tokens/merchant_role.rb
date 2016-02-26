# frozen_string_literal: true
module Shore
  module Client
    module Tokens
      class MerchantRole # :nodoc:
        TYPE = 'merchants'

        attr_accessor :id
        attr_accessor :slug
        attr_accessor :name
        attr_accessor :role
        attr_reader :type

        def initialize(attrs = {})
          @type = TYPE
          self.attributes = attrs
        end

        def attributes=(attrs = {})
          attrs.each_pair do |attr, value|
            if respond_to?(assign = "#{attr}=")
              public_send(assign, value)
            end
          end
        end

        def attributes
          Hash[%i(id slug name role type).map do |attr_name|
            [attr_name, public_send(attr_name)]
          end]
        end
      end
    end
  end
end
