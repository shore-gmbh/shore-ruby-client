# frozen_string_literal: true

module Shore
  module JsonApiClientExt
    # @example
    #    MyJsonApiClass.with_meta(key1: 'value1', key2: 'value2') do
    #      MyJsonApiClass.new.save
    #    end
    #    # => POST /my_json_api_classes
    #    # {
    #    #   'data' => {
    #    #     'type' => 'my_json_api_classes',
    #    #     'meta' => { 'key1' => 'value1', 'key2' => 'value2' }
    #    #   }
    #    # }
    module WithMeta
      extend ActiveSupport::Concern

      module ClassMethods # :nodoc:
        def with_meta(meta)
          @custom_meta = meta
          yield
        ensure
          @custom_meta = nil
        end

        def custom_meta
          @custom_meta
        end
      end

      # @see JsonApiClient::Resource#as_json_api
      def as_json_api(*)
        super.tap do |json_api|
          if (meta = self.class.custom_meta).present?
            json_api[:meta] = meta
          end
        end
      end
    end
  end
end
