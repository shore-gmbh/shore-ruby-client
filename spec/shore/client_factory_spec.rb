class ClientFactoryChild
  include Shore::ClientFactory
end

RSpec.describe ClientFactoryChild do
  describe '#client_class' do
    it 'returns the v1 classes by default' do
      klass = subject.client_class(:appointments)

      expect(klass).to eq(Shore::V1::Appointment)
    end

    it 'returns the class from a specific version when defined' do
      klass = subject.client_class(:appointments, version: :v2)

      expect(klass).to eq(Shore::V2::Appointment)
    end
  end
end
