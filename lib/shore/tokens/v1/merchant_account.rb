require 'shore/tokens/uuid'

module Shore
  module Tokens
    module V1
      class MerchantAccount # :nodoc:
        TYPE = 'ma'.freeze
        attr_reader :id, :type, :name, :version, :organization_id

        # Builds a hash where the Merchant UUID is the key and the Role is the
        # value.
        # @param merchant_uuids [Array<UUID>]
        # @return Hash<UUID,String>
        def roles(merchant_uuids)
          {}.tap do |h|
            merchant_uuids.each do |merchant_uuid|
              h[merchant_uuid] = role(merchant_uuid)
            end
          end
        end

        # Returns a role the merchant belongs to as a string or nil of the
        # MerchantAccount does not have access to the merchant.
        # @param merchant_uuid [UUID] Merchant UUID
        # @return [String]
        def role(merchant_uuid)
          return nil unless include?(merchant_uuid)

          return 'member' if member?(merchant_uuid)
          return 'admin' if admin?(merchant_uuid)
          return 'owner' if owner?(merchant_uuid)

          nil
        end

        # @return [Shore::V1::MerchantAccount]
        def merchant_account
          Shore::V1::MerchantAccount.new(id: id)
        end

        # Just for backwards compatibility in CORE.
        def import_roles(role_entries)
          role_entries.each do |role_entry|
            role_entry = role_entry.with_indifferent_access

            name = role_entry[:role]

            next if name.nil?

            @roles[name.to_sym] << role_entry[:id]
          end
        end

        # @param id [UUID] - MerchantAccount uuid.
        # @param attributes [Hash] - JWT data.
        def initialize(id, attributes = {})
          @id = id
          @name = attributes[:name]
          @type = TYPE
          @version = 1
          @roles = {}
          @organization_id = attributes[:organization_id]

          @roles[:owner] = build_uuids(attributes[:owner] || [])
          @roles[:admin] = build_uuids(attributes[:admin] || [])
          @roles[:member] = build_uuids(attributes[:member] || [])

          import_roles(attributes[:roles]) if attributes[:roles]
        end

        def build_uuids(urlsafe_uuids = [])
          urlsafe_uuids.map { |uuid| Shore::Tokens::UUID.from_urlsafe(uuid) }
        end

        # List of Merchants the MerchantAccount can access
        # @return [Array<UUID>]
        def merchant_uuids
          owners + admins + members
        end

        # Is the role of this Merchant an Owner?
        # @return [Boolean]
        def owner?(merchant_uuid)
          owners.include?(merchant_uuid)
        end

        # Is the role of this Merchant an Admin?
        # @return [Boolean]
        def admin?(merchant_uuid)
          admins.include?(merchant_uuid)
        end

        # Is the role of this Merchant a Member?
        # @return [Boolean]
        def member?(merchant_uuid)
          members.include?(merchant_uuid)
        end

        # Is this Merchant included in the list of Merchants?
        # @return [Boolean]
        def include?(merchant_uuid)
          (m = merchant_uuid) && (owner?(m) || member?(m) || admin?(m))
        end

        # Owner Merchants the MerchantAccount can access
        # @return [Array<UUID>]
        def owners
          @roles[:owner]
        end

        # Member Merchants the MerchantAccount can access
        # @return [Array<UUID>]
        def members
          @roles[:member]
        end

        # Admin Merchants the MerchantAccount can access
        # @return [Array<UUID>]
        def admins
          @roles[:admin]
        end

        # {
        #   id: uuid,
        #   type: 'ma',
        #   version: 1,
        #   data: {
        #     name: 'name',
        #     organization_id: organization_id<uuid>
        #     owner: [uuids],
        #     member: [uuids],
        #     admin: [uuids],
        #   }
        # }
        #

        def as_json
          {
            name: name,
            organization_id: organization_id,
            owner: urlsafe_uuids(owners),
            member: urlsafe_uuids(members),
            admin: urlsafe_uuids(admins)
          }
        end

        def self.parse(payload)
          data = payload.with_indifferent_access
          type = data.try(:[], 'type')
          fail "Incorrect type: '#{type}'" if type != TYPE

          new(data['id'], data['data'])
        end

        private

        def urlsafe_uuids(uuids)
          uuids.map { |uuid| Shore::Tokens::UUID.to_urlsafe(uuid) }
        end
      end
    end
  end
end
