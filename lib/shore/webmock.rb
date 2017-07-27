# frozen_string_literal: true

require 'webmock'
require 'active_support/all'

require 'shore/web_mock_ext/json_api_request_stub'

# Add json:api extensions to WebMock
WebMock::RequestStub.include Shore::WebMockExt::JsonApiRequestStub
