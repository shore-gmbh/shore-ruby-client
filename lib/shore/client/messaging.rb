require 'uri'

module Shore
  module Client
    module Messaging # :nodoc:
      BASE_URI_DEFAULT = 'https://messaging.shore.com/'.freeze unless
        const_defined?(:BASE_URI_DEFAULT)
      private_constant :BASE_URI_DEFAULT

      def base_uri(version)
        # TODO@am: Not sure if this is the best way to do this. It has the
        # big disadvantage that at require time, the url is determined. It
        # would be much better if the user of this library could do something
        # like:
        # require 'shore-client'
        # Shore::Client.configure do
        #   config.messaging_base_uri = ENV['MESSAGING_BASE_URI']
        # end
        base = ENV['MESSAGING_BASE_URI']
        base = BASE_URI_DEFAULT unless base.present?
        uri = URI(base)
        uri.path = '/' + version.to_s
        uri.to_s
      end
      module_function(:base_uri)
    end
  end
end

require_relative 'messaging/v1'
