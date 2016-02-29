RSpec.describe Shore::Client::Tokens::AccessToken do
  let(:exp) { (Time.now.utc + 2.days).beginning_of_day }
  let(:secret) { 'secret' }
  let(:member_role) do
    {
      id: '74eb402b-e159-4027-9363-60772e6e8930',
      type: 'merchants',
      slug: 'achsel-alex',
      name: 'Achsel Alex',
      role: 'member'
    }.with_indifferent_access
  end
  let(:valid_jwt_payload) do
    {
      exp: exp.to_i,
      data: {
        id: '226fc766-3cf0-4d18-a988-5f8235f17edb',
        type: 'merchant-accounts',
        attributes: {
          name: 'Bob Barker',
          roles: [member_role]
        }
      }
    }.with_indifferent_access
  end

  describe '.parse_auth_header' do
    let(:valid_auth_header) do
      "Bearer #{JWT.encode(valid_jwt_payload, secret, 'HS256')}"
    end

    it 'returns an AccessToken' do
      expect(
        described_class.parse_auth_header(valid_auth_header, secret))
        .to be_an_instance_of(described_class)
    end

    context 'when exp set with env variable' do
      it 'fails' do
        ENV['JWT_TOKEN_EXPIRE_IN_MINUTES'] = '60'
        expect do
          auth_header = "Bearer #{JWT.encode(valid_jwt_payload.except('exp'),
                                             secret,
                                             'HS256')}"
          described_class.parse_auth_header(auth_header, secret)
        end.not_to raise_error
      end
    end

    context 'when expiration time has past' do
      let(:exp) { (Time.now.utc - 2.days).beginning_of_day }
      it 'fails' do
        expect do
          described_class.parse_auth_header(valid_auth_header, secret)
        end.to raise_error(Shore::Client::Tokens::InvalidTokenError)
      end
    end

    context 'when header is blank' do
      it 'fails' do
        expect do
          described_class.parse_auth_header('', secret)
        end.to raise_error(Shore::Client::Tokens::InvalidTokenError)
      end
    end

    context 'when header is not a valid jwt' do
      it 'fails' do
        expect do
          described_class.parse_auth_header(
            'Bearer blahblahblahblah', secret)
        end.to raise_error(Shore::Client::Tokens::InvalidTokenError)
      end
    end

    context 'when the secret is wrong' do
      let(:wrong_secret) { 'the-wrong-secret' }
      it 'fails' do
        expect(wrong_secret).to_not eq(secret)
        expect do
          described_class.parse_auth_header(
            valid_auth_header, wrong_secret)
        end.to raise_error(Shore::Client::Tokens::InvalidTokenError)
      end
    end
  end

  describe '#to_jwt' do
    context 'with valid exp' do
      subject(:jwt) do
        described_class.new(account: valid_jwt_payload['data']).to_jwt(secret)
      end

      it 'creates jwt' do
        expect(jwt.split('.').size).to eq(3)
      end
    end

    context 'without exp' do
      subject(:jwt) do
        described_class.new(account: valid_jwt_payload['data'], exp: exp)
          .to_jwt(secret)
      end

      it 'creates jwt' do
        expect(jwt.split('.').size).to eq(3)
      end

      it 'parses jwt header' do
        header = jwt.split('.')[0]
        expect(JSON(Base64.decode64(header)))
          .to eq('typ' => 'JWT', 'alg' => 'HS256')
      end

      it 'parses jwt payload' do
        payload = jwt.split('.')[1]
        expect(JSON(Base64.decode64(payload))).to eq(valid_jwt_payload)
      end
    end

    context 'without account data' do
      subject(:access_token) { described_class.new(exp: Time.now + 1.minute) }

      it 'fails with InvalidTokenError' do
        expect { access_token.to_jwt(secret) }
          .to raise_error(Shore::Client::Tokens::InvalidTokenError)
      end
    end
  end
end
