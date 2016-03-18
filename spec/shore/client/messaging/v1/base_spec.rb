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
    auth_header = 'Bearer abcde.fghi.jklmno'
    Shore::Client.with_authorization(auth_header) do
      expect(Shore::Client.authorization).to eq auth_header
      expect(auth_header(perform)).to eq auth_header
    end
  end

  it 'does not add headers' do
    expect(Shore::Client.authorization).to be_nil
    expect(auth_header(perform)).to be_nil
  end
end
