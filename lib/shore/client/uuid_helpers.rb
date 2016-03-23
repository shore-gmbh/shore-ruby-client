module Shore
  module Client
    # Convert UUIDs into a smaller more compact and also URL safe
    # representation.
    module UUID
      UUID_FORMAT = 'H8H4H4H4H12'

      # from_urlsafe("uUtUi3QLle6IvU1oOYIezg")
      # => "b94b548b-740b-95ee-88bd-4d6839821ece"
      def self.from_urlsafe(url)
        url = url.tr('_', '/').tr('-', '+')
        url.unpack('m').first.unpack(UUID_FORMAT).join('-')
      end

      # to_urlsafe('b94b548b-740b-95ee-88bd-4d6839821ece')
      # => "uUtUi3QLle6IvU1oOYIezg"
      def self.to_urlsafe(uuid)
        bytestring = uuid.split('-').pack(UUID_FORMAT)
        Base64.urlsafe_encode64(bytestring).tr('=', '')
      end
    end
  end
end
