require_relative 'invalid_token_error'
require_relative 'merchant_account'
require_relative 'merchant_role'

module Shore
  module Client
    module Tokens
      # @example JWT Payload
      # {
      #   "exp": 1455120875,
      #   "data": {
      #     "id": "226fc766-3cf0-4d18-a988-5f8235f17edb",
      #     "type": "merchant-accounts",
      #     "attributes": {
      #       "name": "Alex Smith",
      #       "roles": [
      #         {
      #           "id": "74eb402b-e159-4027-9363-60772e6e8930",
      #           "type": "merchants",
      #           "slug": "achsel-alex",
      #           "name": "Achsel Alex",
      #           "role": "member"
      #         }
      #       ]
      #     }
      #   }
      # }
      class AccessToken
        require 'jwt'

        JWT_ALGORITHM = 'HS256'.freeze
        private_constant :JWT_ALGORITHM

        attr_accessor :exp
        attr_accessor :account

        # @example auth_header
        #     Bearer eyJhbGciOiJIUz.eyJzdWIiOiIx.DcEfxjoYZgeFONFh7HgQ
        #
        # @param auth_header [String]
        # @param secret [String]
        # @raise InvalidTokenError if the auth_header does not contain a valid
        #   token
        # @raise TokenExpiredError if the token is valid, but has expired
        # rubocop:disable all
        def self.parse_auth_header(auth_header, secret)
          fail InvalidTokenError,
               'No authorization header' if auth_header.blank?
          token = auth_header.split(' ').last
          fail InvalidTokenError,
               'Wrong authorization header format' if token.blank?
          decoded_token = JWT.decode(token, secret, true,
                                     algorithm: JWT_ALGORITHM)
          parse_jwt_payload(decoded_token.first)
        rescue JWT::ExpiredSignature => error
          raise InvalidTokenError, error.message, error.backtrace
        rescue JWT::DecodeError => error
          raise InvalidTokenError, error.message, error.backtrace
        end
        # rubocop:enable all

        # @param jwt_payload [Hash]
        def self.parse_jwt_payload(jwt_payload)
          exp = Time.at(jwt_payload['exp']) if jwt_payload['exp'].present?
          account = Shore::Client::Tokens::MerchantAccount
                    .parse(jwt_payload['data'])

          new(exp: exp, account: account)
        end

        # @param options [Hash]
        # @option options [String] :exp
        # @option options [Shore::Client::Tokens::MerchantAccount] :account
        #   that is granted access via this token. Mandatory.
        def initialize(options = {})
          options = options.with_indifferent_access
          init_exp(options)
          @account = options[:account]
        end

        # @param secret [String]
        def to_jwt(secret)
          fail InvalidTokenError, 'Account is missing' unless account
          payload = {}
          payload['exp'] = exp.to_i if exp
          payload['data'] = account.as_json
          JWT.encode(payload, secret, JWT_ALGORITHM)
        end

        private

        def init_exp(options)
          @exp = if options.key?(:exp)
                   options[:exp]
                 elsif ENV['JWT_TOKEN_EXPIRE_IN_MINUTES'].present?
                   Time.now + ENV['JWT_TOKEN_EXPIRE_IN_MINUTES'].to_i.minutes
                 end
        end
      end
    end
  end
end
