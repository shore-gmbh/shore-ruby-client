module Shore
  module Client
    # Adds {url} method to the class.
    module WithUrl
      extend ActiveSupport::Concern

      module ClassMethods # :nodoc:
        def url(params = {})
          path = requestor.send(:resource_path, params.slice(:id))
          connection = requestor.send(:connection)
          connection.faraday.build_url(path, extra_params(params)).to_s
        end

        private

        def extra_params(params)
          # The id was used in the path. These are just the query parameters.
          params.except(:id).tap do |extra|
            if (filter = extra[:filter])
              # Convert `{ filter: { id: [Resource<id: 1>, Resource<id: 2>]}}`
              # into    `{ filter: { id: '1,2'}}`
              extra[:filter] = convert_filter(filter)
            end
          end
        end

        def convert_filter(filter)
          Hash[
            filter.to_a.map { |key, value| [key, convert_filter_value(value)] }
          ]
        end

        def convert_filter_value(value)
          if value.is_a?(Array)
            value.map { |item| item.respond_to?(:id) ? item.id : item.to_s }
              .join(',')
          else
            value.respond_to?(:id) ? value.id : value.to_s
          end
        end
      end

      def url(params = {})
        self.class.url(params.with_indifferent_access.merge(id: id))
      end
    end
  end
end
