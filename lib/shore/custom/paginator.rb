# frozen_string_literal: true

module Shore
  module Custom
    # @see https://github.com/JsonApiClient/json_api_client#custom-paginator
    class Paginator < JsonApiClient::Paginating::Paginator
      self.page_param = 'number'
      self.per_page_param = 'size'
    end
  end
end
