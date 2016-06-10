module Shore
  module Tokens
    module Helpers
      def urlsafe_uuid(uuid)
        Shore::Tokens::UUID.to_urlsafe(uuid)
      end

      def admin_merchant(id = nil)
        {
          id: id || SecureRandom.uuid,
          role: 'admin'
        }
      end

      def owner_merchant(id = nil)
        {
          id: id || SecureRandom.uuid,
          role: 'owner'
        }
      end

      def member_merchant(id = nil)
        {
          id: id || SecureRandom.uuid,
          role: 'member'
        }
      end

      def merchant_account_token(id, members)
        t = Shore::Tokens::V1::MerchantAccount.new(id)
        t.import_roles(members)
        t
      end
    end
  end
end

RSpec.configure do |config|
  config.include Shore::Tokens::Helpers
end
