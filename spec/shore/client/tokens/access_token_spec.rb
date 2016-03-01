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

  describe '.initialize' do
    it 'ignores :exp_minutes_from_now if :exp set' do
      expect(described_class.new(exp: exp, exp_minutes_from_now: '1').exp)
        .to eq(exp)
    end

    it 'sets exp if :exp not set, but :exp_minutes_from_now is' do
      Timecop.freeze do
        expect(described_class.new(exp_minutes_from_now: '13').exp)
          .to eq(Time.now + 13.minutes)
      end
    end
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
    context 'without exp' do
      subject(:jwt) do
        described_class.new(account: valid_jwt_payload['data']).to_jwt(secret)
      end

      it 'creates jwt' do
        expect(jwt.split('.').size).to eq(3)
      end
    end

    context 'with exp' do
      subject(:jwt) do
        described_class.new(account: valid_jwt_payload['data'], exp: exp)
          .to_jwt(secret)
      end
      let(:header) { JSON(Base64.decode64(jwt.split('.')[0])) }
      let(:payload) { JSON(Base64.decode64(jwt.split('.')[1])) }

      it 'creates jwt' do
        expect(jwt.split('.').size).to eq(3)
      end

      it 'parses jwt header' do
        expect(header).to eq('typ' => 'JWT', 'alg' => 'HS256')
      end

      it 'parses jwt payload' do
        expect(payload).to eq(valid_jwt_payload)
      end

      it 'sets the expiration' do
        expect(payload['exp']).to eq(exp.to_i)
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

  describe '#expired?' do
    context 'when valid exp is set' do
      let(:access_token) { described_class.new(exp: exp) }

      it 'returns false' do
        expect(access_token.expired?).to be_falsey
      end
    end

    context 'when exp is not set' do
      let(:access_token) { described_class.new }

      it 'returns true' do
        expect(access_token.expired?).to be_truthy
      end
    end
  end
end
