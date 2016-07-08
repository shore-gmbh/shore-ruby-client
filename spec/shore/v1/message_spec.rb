require 'shore/v1'

RSpec.describe Shore::V1::Message do
  include_examples 'shore json api client' do
    let(:site) { 'https://api.shore.com/v1' }
  end

  describe '.read' do
    let(:id) { '11111111-1111-1111-1111-111111111111' }
    let(:instance) do
      described_class.load(id: id, attr_name: 'Attribute value')
    end

    let(:read_message_url) { instance.url + '/read' }

    subject { described_class.find(id).first }

    before do
      stub_request(:get, instance.url).to_return_jsonapi(data: instance)
    end

    it 'returns client instance if success' do
      stub_request(:patch, read_message_url)
        .to_return_jsonapi(data: instance)
      expect(found = subject.read.first).to eq(instance)
      expect(found.attr_name).to eq('Attribute value')
    end

    it 'raises error if not found' do
      stub_request(:patch, read_message_url)
        .to_return_jsonapi(status: 404,
                           errors: [{ 'title' => 'Not Found' }])
      expect do
        subject.read
      end.to raise_error JsonApiClient::Errors::NotFound
    end

    it 'raises error if not authorized' do
      stub_request(:patch, read_message_url)
        .to_return_jsonapi(status: 401,
                           errors: [{ 'title' => 'Not Authorized' }])
      expect do
        subject.read
      end.to raise_error JsonApiClient::Errors::NotAuthorized
    end
  end
end
