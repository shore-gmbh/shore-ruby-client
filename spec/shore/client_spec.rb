RSpec.describe Shore::Client do
  describe '.with_access_token' do
    let(:id) { SecureRandom.uuid }
    let(:auth_header) { 'Bearer abcde.fghij.jlmnoi' }

    it 'returns message' do
      stub_success_request(id, auth_header)
      described_class.with_authorization(auth_header) do
        message = Shore::Client::Messaging::V1::Message.find(id).first
        expect(message.id).to eq id
        expect(message.type).to eq 'messages'
        expect(message.content).to eq 'Test message'
      end
    end

    it 'raises error if not authorized' do
      stub_not_authorized_request(id)
      expect { Shore::Client::Messaging::V1::Message.find(id).first }
        .to raise_error JsonApiClient::Errors::NotAuthorized
    end

    it 'raises error if not found' do
      stub_not_found_request(id, auth_header)
      described_class.with_authorization(auth_header) do
        expect { Shore::Client::Messaging::V1::Message.find(id).first }
          .to raise_error JsonApiClient::Errors::NotFound
      end
    end
  end
end
