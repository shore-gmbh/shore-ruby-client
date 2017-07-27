# frozen_string_literal: true

module Shore
  module WebMockExt
    # Adds json:api helpers
    module JsonApiRequestStub
      extend ActiveSupport::Concern

      MEDIA_TYPE = 'application/vnd.api+json'

      def to_return_jsonapi(*response_hashes)
        ja_hashes = [*response_hashes].flatten.map do |r|
          r.except(:data, :errors, :included).tap do |new_r|
            if (new_body = body(r.slice(:data, :errors, :included)))
              new_r[:body] = new_body
            end
            new_r[:headers] ||= {}
            new_r[:headers]['Content-Type'] = MEDIA_TYPE
          end
        end
        to_return(*ja_hashes)
      end

      private

      def body(data: nil, errors: nil, included: nil)
        if data
          data_body(data: data, included: included)
        elsif errors
          { errors: errors }.to_json
        else
          raise 'Error: either :data or :errors must be given!'
        end
      end

      def data_body(data:, included: nil)
        body = {}
        body['data'] = data.is_a?(Array) ? data.map(&:as_json) : data.as_json
        body['included'] = included.map(&:as_json) if included
        body.to_json
      end
    end
  end
end
