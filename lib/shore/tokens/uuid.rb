module Shore
  module Tokens
    # Convert UUIDs into a smaller more compact and also URL safe
    # representation.
    module UUID
      UUID_FORMAT = 'H8H4H4H4H12'

      # from_urlsafe("uUtUi3QLle6IvU1oOYIezg")
      # => "b94b548b-740b-95ee-88bd-4d6839821ece"
      def from_urlsafe(url)
        return if url.blank?
        url = url.tr('_', '/').tr('-', '+')
        url.unpack('m').first.unpack(UUID_FORMAT).join('-')
      end
      module_function :from_urlsafe

      # to_urlsafe('b94b548b-740b-95ee-88bd-4d6839821ece')
      # => "uUtUi3QLle6IvU1oOYIezg"
      def to_urlsafe(uuid)
        return if uuid.blank?
        bytestring = uuid.split('-').pack(UUID_FORMAT)
        Base64.urlsafe_encode64(bytestring).tr('=', '')
      end
      module_function :to_urlsafe
    end
  end
end
