require 'webmock'
require 'active_support/all'

module Shore
  # The gem `webmock` uses the module name `WebMock` even though it should
  # be called `Webmock`. To remain consistent with their naming convention,
  # we'll follow the same naming convention (i.e. file named `shore/webmock.rb`
  # and module named `Shore::WebMock`).
  module WebMock
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
        if data.present?
          data_body(data: data, included: included)
        elsif errors
          { errors: errors }.to_json
        else
          fail 'Error: either :data or :errors must be given!'
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

module WebMock
  class RequestStub # :nodoc:
    include Shore::WebMock::JsonApiRequestStub
  end
end
