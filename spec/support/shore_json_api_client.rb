# frozen_string_literal: true

# @example
#   RSpec.describe MyClass do
#     include_examples 'shore json api client' do
#       let(:site) { 'https://api.shore.com/v1' }
#     end
#   end
RSpec.shared_examples 'shore json api client' do
  describe '.url' do
    context 'without params' do
      subject { described_class.url }

      it { is_expected.to eq(url) }
    end
  end

  describe '.find(:id).first' do
    let(:id) { '11111111-1111-1111-1111-111111111111' }
    let(:instance) do
      described_class.load(id: id, attr_name: 'Attribute value')
    end

    subject { described_class.find(id).first }

    it 'returns client instance if success' do
      stub_request(:get, instance.url)
        .to_return_jsonapi(data: instance)
      expect(found = subject).to eq(instance)
      expect(found.attr_name).to eq('Attribute value')
    end

    it 'raises error if not found' do
      stub_request(:get, instance.url)
        .to_return_jsonapi(status: 404,
                           errors: [{ 'title' => 'Not Found' }])
      expect do
        subject
      end.to raise_error JsonApiClient::Errors::NotFound
    end

    it 'raises error if not authorized' do
      stub_request(:get, instance.url)
        .to_return_jsonapi(status: 401,
                           errors: [{ 'title' => 'Not Authorized' }])
      expect do
        subject
      end.to raise_error JsonApiClient::Errors::NotAuthorized
    end
  end

  describe '.all' do
    let(:id) { '11111111-1111-1111-1111-111111111111' }
    let(:instance) do
      described_class.load(id: id, attr_name: 'Attribute value')
    end

    subject { described_class.all }

    it 'returns array of client instances if success' do
      stub_request(:get, described_class.url)
        .to_return_jsonapi(data: [instance])
      expect(subject).to contain_exactly(instance)
      expect(subject.first.attr_name).to eq('Attribute value')
    end
  end
end
