require 'json_api_client'

module Shore
  module JsonApiClient
    # Enumerate through all pages.
    # @see JsonApiClient::Query::Builder
    module BulkFinder
      extend ActiveSupport::Concern

      # @example #find_each
      #   MyJsonApiClass.where(...).per(20).find_each do |x|
      #     ...
      #   end
      def find_each
        bulk.each { |result| yield result }
      end

      # @example #bulk
      #   MyJsonApiClass.per(3).bulk.map { |x| x.id }
      #   # => [1,2,3]
      def bulk
        Enumerator.new do |y|
          results = all
          # TODO@am: Handle case in which results.errors.present?
          while results.present?
            results.each { |result| y.yield result }
            results = next_bulk_page(results)
          end
        end
      end

      private

      def next_bulk_page(results)
        # #all returns a JsonApiClient::ResultSet. Lets also support an
        # Array in case this call is mocked in a test with...
        # expect_any_instance_of(JsonApiClient::Query::Requestor)
        #   .to receive(:get).and_return([])
        results.pages.next if results.respond_to?(:links) && results.links &&
                              results.respond_to?(:pages) && results.pages &&
                              results.links.links['next'].present?
      end
    end
  end
end

JsonApiClient::Query::Builder.include(Shore::JsonApiClient::BulkFinder)
