RSpec.describe ShoreClientMiddleware do
  def auth_header(env)
    env[:request_headers]['Authorization']
  end

  def perform(headers = {})
    env = { request_headers: headers }
    app = make_app
    app.call(env)
  end

  def make_app
    described_class.new(->(env) { env })
  end

  let(:token) { 'secret token' }

  it 'does not raise error if called from block' do
    Shore::Client.with_access_token(token) do
      expect(Shore::Client.access_token).to eq token
      expect(auth_header(perform)).to eq token
    end
  end

  it 'raises error if called outside the block' do
    expect { auth_header(perform) }
      .to raise_error(Shore::Client::Tokens::InvalidTokenError)
  end
end
