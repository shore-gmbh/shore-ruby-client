RSpec.describe Shore::Client do
  describe '.with_access_token' do
    let(:id) { SecureRandom.uuid }
    let(:auth_header) { 'Bearer abcde.fghij.jlmnoi' }

    it 'returns message' do
      stub_messaging_success_request(id, auth_header)
      described_class.with_authorization(auth_header) do
        message = Shore::Client::V1::Message.find(id).first
        expect(message.id).to eq id
        expect(message.type).to eq 'messages'
        expect(message.content).to eq 'Test message'
      end
    end

    it 'raises error if not authorized' do
      stub_messaging_not_authorized_request(id)
      expect { Shore::Client::V1::Message.find(id).first }
        .to raise_error JsonApiClient::Errors::NotAuthorized
    end

    it 'raises error if not found' do
      stub_messaging_not_found_request(id, auth_header)
      described_class.with_authorization(auth_header) do
        expect { Shore::Client::V1::Message.find(id).first }
          .to raise_error JsonApiClient::Errors::NotFound
      end
    end

    it 'returns merchant_account' do
      stub_core_success_request(id, auth_header)
      described_class.with_authorization(auth_header) do
        merchant_account = Shore::Client::V1::MerchantAccount.find.first
        expect(merchant_account.id).to eq id
        expect(merchant_account.display_name).to eq 'Test'
        expect(merchant_account.name).to eq 'Test'
        expect(merchant_account.email).to eq 't@test.com'
      end
    end

    it 'raises error for core if not authorized' do
      stub_core_not_authorized_request
      expect { Shore::Client::V1::MerchantAccount.find.first }
        .to raise_error JsonApiClient::Errors::NotAuthorized
    end

    it 'raises error if service unknown' do
      expect { Shore::Client::Services.url_for(:unknown, :v1) }
        .to raise_error Shore::Client::NoServiceEnvironmentVariable
    end
  end
end
