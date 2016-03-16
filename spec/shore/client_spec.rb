RSpec.describe Shore::Client do
  describe '.with_access_token' do
    before do
      stub_request(:get,
                   "#{Shore::Client::Messaging.base_uri(:v1)}/messages/abc1")
        .with(
          headers: {
            'Authorization' => 'some token',
            'Content-Type' => 'application/vnd.api+json'
          }
        ).to_return(
          headers: { content_type: 'application/vnd.api+json' },
          body: {
            data: {
              type: 'messages',
              id: 'abc1',
              attributes: {
                content: 'Test message'
              }
            }
          }.to_json
        )
    end

    it 'returns message if called from block' do
      described_class.with_access_token('some token') do
        message = Shore::Client::Messaging::V1::Message.find('abc1').first
        expect(message.id).to eq 'abc1'
        expect(message.type).to eq 'messages'
        expect(message.content).to eq 'Test message'
      end
    end

    it 'raises error if called outside block' do
      expect { Shore::Client::Messaging::V1::Message.find('abc1').first }
        .to raise_error(Shore::Client::Tokens::InvalidTokenError)
    end
  end
end
