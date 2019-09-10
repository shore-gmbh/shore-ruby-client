# frozen_string_literal: true

require 'uri'

module Shore
  module JsonApiClientExt
    # @example
    #   class V5::MyBaseClass < JsonApiClient::Resource
    #     include Shore::Services
    #     self.site = base_url(:v5)
    module VersionableApi
      extend ActiveSupport::Concern

      DEFAULT_BASE_URI = 'https://api.shore.com'

      module ClassMethods # :nodoc:
        def base_url(version)
          base_uri = ENV['SHORE_API_INTERNAL_BASE_URI']
          base_uri = DEFAULT_BASE_URI if base_uri.blank?

          uri = URI(base_uri)
          uri.path = "/#{version}"
          uri.to_s
        end
      end
    end
  end
end
