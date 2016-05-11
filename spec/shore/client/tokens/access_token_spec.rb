RSpec.describe Shore::Client::Tokens::AccessToken do
  let(:exp) { (Time.now.utc + 2.days).beginning_of_day }
  let(:algorithm) { 'HS256' }
  let(:public_key) { 'secret' }
  let(:private_key) { 'secret' }
  let(:member) { member_merchant }
  let(:merchant_token) do
    merchant_account_token(SecureRandom.uuid, [member])
  end
  let(:valid_jwt_payload) do
    described_class.new(
      data: merchant_token,
      exp: exp
    )
  end

  describe '.initialize' do
    it 'ignores :exp_minutes_from_now if :exp set' do
      expires = described_class.new(exp: exp, exp_minutes_from_now: '1').exp
      expect(expires).to eq(exp)
    end

    it 'sets exp if :exp not set, but :exp_minutes_from_now is' do
      Timecop.freeze do
        expires = described_class.new(exp_minutes_from_now: '13').exp
        expect(expires).to eq(Time.now + 13.minutes)
      end
    end
  end

  describe '.parse_auth_header' do
    let(:valid_auth_header) do
      jwt = valid_jwt_payload.to_jwt(private_key: private_key,
                                     algorithm: algorithm)
      "Bearer #{jwt}"
    end

    it 'returns an AccessToken' do
      token = described_class.parse_auth_header(
        valid_auth_header, public_key: public_key, algorithm: algorithm)
      expect(token).to be_an_instance_of(described_class)
    end

    it 'has data' do
      token = described_class.parse_auth_header(
        valid_auth_header, public_key: public_key, algorithm: algorithm)
      expect(token.data).not_to be_nil
    end

    context 'when expiration time has past' do
      let(:exp) { (Time.now.utc - 2.days).beginning_of_day }

      it 'fails with InvalidTokenError' do
        expect do
          described_class.parse_auth_header(
            valid_auth_header, public_key: public_key, algorithm: algorithm)
        end.to raise_error(Shore::Client::Tokens::InvalidTokenError)
      end
    end

    context 'when header is blank' do
      it 'fails with InvalidTokenError' do
        expect do
          described_class.parse_auth_header(
            '', public_key: public_key, algorithm: algorithm)
        end.to raise_error(Shore::Client::Tokens::InvalidTokenError)
      end
    end

    context 'when header is not a valid jwt' do
      it 'fails with InvalidTokenError' do
        expect do
          described_class.parse_auth_header(
            'Bearer nope', public_key: public_key, algorithm: algorithm)
        end.to raise_error(Shore::Client::Tokens::InvalidTokenError)
      end
    end

    context 'when the public_key is wrong' do
      let(:wrong_public_key) { 'the-wrong-public-key' }
      before { expect(wrong_public_key).to_not eq(public_key) }
      it 'fails with InvalidTokenError' do
        expect do
          described_class.parse_auth_header(
            valid_auth_header,
            public_key: wrong_public_key, algorithm: algorithm)
        end.to raise_error(Shore::Client::Tokens::InvalidTokenError)
      end
    end

    context 'when the algorithm is wrong' do
      let(:algorithm) { 'HS384' }
      let(:wrong_algorithm) { 'the-wrong-secret' }
      before { expect(wrong_algorithm).to_not eq(algorithm) }
      it 'fails with InvalidTokenError' do
        expect do
          described_class.parse_auth_header(
            valid_auth_header,
            public_key: public_key, algorithm: wrong_algorithm)
        end.to raise_error(Shore::Client::Tokens::InvalidTokenError)
      end
    end

    context 'when the public key is not provided' do
      it 'fails with InvalidTokenError' do
        expect do
          described_class.parse_auth_header(
            valid_auth_header, public_key: nil, algorithm: algorithm)
        end.to raise_error(Shore::Client::Tokens::InvalidTokenError)
      end
    end

    context 'when the algorithm is not provided' do
      it 'fails with InvalidTokenError' do
        expect do
          described_class.parse_auth_header(
            valid_auth_header, public_key: public_key, algorithm: nil)
        end.to raise_error(Shore::Client::Tokens::InvalidTokenError)
      end
    end

    context 'when the algorithm is invalid' do
      it 'fails with InvalidTokenError' do
        expect do
          described_class.parse_auth_header(
            valid_auth_header, public_key: public_key, algorithm: 'invalid-alg')
        end.to raise_error(Shore::Client::Tokens::InvalidTokenError)
      end
    end
  end

  describe '#to_jwt' do
    context 'without exp' do
      subject(:jwt) do
        described_class.new(data: merchant_token)
          .to_jwt(private_key: private_key, algorithm: algorithm)
      end

      it 'creates jwt' do
        expect(jwt.split('.').size).to eq(3)
      end
    end

    context 'with exp' do
      subject(:jwt) do
        described_class.new(data: merchant_token, exp: exp)
          .to_jwt(private_key: private_key, algorithm: algorithm)
      end
      let(:header) { JSON(Base64.decode64(jwt.split('.')[0])) }
      let(:payload) { JSON(Base64.decode64(jwt.split('.')[1])) }

      it 'creates jwt' do
        expect(jwt.split('.').size).to eq(3)
      end

      it 'parses jwt header' do
        expect(header).to eq('typ' => 'JWT', 'alg' => algorithm)
      end

      it 'parses jwt payload' do
        expect(payload).to match(
          a_hash_including(
            'id'      => merchant_token.id,
            'type'    => merchant_token.type,
            'version' => merchant_token.version,
            'data'    => merchant_token.as_json.with_indifferent_access
          )
        )
      end

      it 'sets the expiration' do
        expect(payload['exp']).to eq(exp.to_i)
      end
    end

    context 'without account data' do
      subject(:access_token) { described_class.new(exp: Time.now + 1.minute) }

      it 'fails with InvalidTokenError' do
        expect do
          access_token.to_jwt(private_key: private_key, algorithm: algorithm)
        end.to(raise_error(Shore::Client::Tokens::InvalidTokenError))
      end
    end
  end

  describe '.valid_format?' do
    let(:valid_bearer_auth_header_format) do
      jwt = valid_jwt_payload.to_jwt(private_key: private_key,
                                     algorithm: algorithm)
      "Bearer #{jwt}"
    end

    let(:invalid_token_auth_header_format) do
      jwt = valid_jwt_payload.to_jwt(private_key: private_key,
                                     algorithm: algorithm)
      "Token token=#{jwt}"
    end

    let(:invalid_bearer_auth_header_format) { 'Bearer nope' }

    it "returns 'true' for valid Bearer format" do
      expect(described_class.valid_format?(valid_bearer_auth_header_format))
        .to be_truthy
    end

    it "returns 'false' for 'Token token=' format" do
      expect(described_class.valid_format?(invalid_token_auth_header_format))
        .to be_falsey
    end

    it "returns 'false' for invalid token format" do
      expect(described_class.valid_format?(invalid_bearer_auth_header_format))
        .to be_falsey
    end
  end
end
