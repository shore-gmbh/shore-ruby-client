require 'jwt'
require_relative 'invalid_token_error'
require_relative 'v1/merchant_account'

module Shore
  module Tokens
    # @example JWT Payload
    # {
    #   "exp": 1455120875,
    #   "id": ["uUtUi3QLle6IvU1oOYIezg"],
    #   "version": 1,
    #   "type": "ma",
    #   "data": {
    #     "name": "Bob Barker",
    #     "organization_id": "gQG5vk7xTVWGOxmAfMEq8w",
    #     "owner": ["uUtUi3QLle6IvU1oOYIezg"],
    #     "member": ["uUtUi3QLle6IvU1oOYIezg"],
    #     "admin": ["uUtUi3QLle6IvU1oOYIezg"]
    #   }
    # }
    #
    class AccessToken
      attr_accessor :exp
      attr_accessor :data

      # @example auth_header
      #     Bearer eyJhbGciOiJIUz.eyJzdWIiOiIx.DcEfxjoYZgeFONFh7HgQ
      #
      # @param auth_header [String]
      # @param public_key [String] The key used to verify the JWT signature
      # @param algorithm [String] The algorithm used to encrypt the JWT
      #   signature (e.g. 'RS256')
      # @raise InvalidTokenError if the auth_header does not contain a valid
      #   token
      # @raise TokenExpiredError if the token is valid, but has expired
      def self.parse_auth_header(auth_header, public_key:, algorithm:)
        if auth_header.blank?
          fail InvalidTokenError,
               'The required header, Authorization, is missing.'
        end
        _parse_auth_header(auth_header,
                           public_key: public_key, algorithm: algorithm)
      rescue JWT::ExpiredSignature => error
        raise InvalidTokenError, error.message, error.backtrace
      rescue JWT::DecodeError => error
        raise InvalidTokenError, error.message, error.backtrace
      end

      # @param jwt_payload [Hash]
      def self.parse_jwt_payload(payload)
        expires = Time.at(payload['exp']) if payload['exp'].present?
        type = payload['type']
        version = payload['version']

        if type == Tokens::V1::MerchantAccount::TYPE && version == 1
          data = Shore::Tokens::V1::MerchantAccount.parse(payload)
        end

        new(exp: expires, data: data)
      end

      # @see parse_auth_header
      def self._parse_auth_header(auth_header, public_key:, algorithm:)
        token = extract_token(auth_header)

        if token.blank?
          fail InvalidTokenError, 'Wrong authorization header format'
        end

        decoded_token = JWT.decode(
          token, public_key.to_s, true, algorithm: algorithm.to_s
        )

        parse_jwt_payload(decoded_token.first)
      end

      private_class_method :_parse_auth_header

      # @param [String] the value of the Authorization request header
      def self.valid_format?(auth_header)
        extract_token(auth_header).present?
      end

      # @example Bearer JWT token
      #   Bearer asdjsdli23.laskjfasldfjlk.asd32423
      # @param [String] the value of the Authorization request header
      def self.extract_token(auth_header)
        auth_header.to_s.match(
          /^(?:Bearer\s+)
          ([A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_=]+)$/x
        ).try(:captures).try(:first)
      end
      private_class_method :extract_token

      # @param options [Hash]
      # @option options [String] :exp
      # @option options [Hash] :data (implements .type, .id and .as_json)
      def initialize(options = {})
        options = options.with_indifferent_access
        assign_expiration(options)
        @data = options[:data]
      end

      # @param private_key [String] The key to use to encrypt the
      #   JWT signature
      # @param algorithm [String] The algorithm to use to encrypt the
      #   JWT signature (e.g. 'RS256')
      def to_jwt(private_key:, algorithm:)
        fail InvalidTokenError, 'Data is missing' unless data

        JWT.encode(jwt_payload, private_key.to_s, algorithm.to_s)
      end

      private

      def jwt_payload
        {}.tap do |payload|
          payload['id'] = data.id
          payload['exp'] = exp.to_i if exp
          payload['version'] = data.version
          payload['type'] = data.type
          payload['data'] = data.as_json
        end
      end

      def assign_expiration(options)
        @exp = if options.key?(:exp)
                 options[:exp]
               elsif (minutes = options[:exp_minutes_from_now]).present?
                 Time.now + minutes.to_i.minutes
               end
      end
    end
  end
end
