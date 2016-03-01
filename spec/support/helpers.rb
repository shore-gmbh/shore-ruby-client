module Shore
  module Client
    module RSpec
      module Helpers
        def merchant_role(attributes = {})
          {
            id: '74eb402b-e159-4027-9363-60772e6e8930',
            type: 'merchants',
            slug: 'achsel-alex',
            name: 'Achsel Alex',
            role: 'member'
          }.with_indifferent_access.deep_merge(attributes)
        end

        def merchant_account(attributes = {}, roles = [merchant_role])
          {
            'id' => '226fc766-3cf0-4d18-a988-5f8235f17edb',
            'type' => 'merchant-accounts',
            'attributes' => {
              'name' => 'Bob Barker',
              'roles' => roles
            }
          }.with_indifferent_access.deep_merge(attributes)
        end

        def jwt_payload(exp: (Time.now.utc + 2.days).beginning_of_day,
                        member_roles: [member_role],
                        attributes: {})
          { exp: exp.to_i,
            data: {
              id: '226fc766-3cf0-4d18-a988-5f8235f17edb',
              type: 'merchant-accounts',
              attributes: {
                name: 'Bob Barker',
                roles: member_roles } }
          }.with_indifferent_access.deep_merge(attributes)
        end
      end
    end
  end
end
