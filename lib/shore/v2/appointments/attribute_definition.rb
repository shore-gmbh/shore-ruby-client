# frozen_string_literal: true

require_relative '../client_base'

module Shore
  module V2
    module Appointments
      # @see https://docs.shore.com/v2/#appointments_attribute_definitions
      class AttributeDefinition < ClientBase
        def self.table_name
          'appointments_attribute_definitions'
        end
      end
    end
  end
end
