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

  it 'returns headers if called from block' do
    token = 'abcde.fghi.jklmno'
    Shore::Client.with_access_token(token) do
      expect(Shore::Client.access_token).to eq token
      expect(auth_header(perform)).to eq "Bearer #{token}"
    end
  end

  it 'does not add headers' do
    expect(Shore::Client.access_token).to be_nil
    expect(auth_header(perform)).to be_nil
  end
end
