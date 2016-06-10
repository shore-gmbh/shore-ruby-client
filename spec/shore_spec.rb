RSpec.describe Shore do
  it 'has a version number' do
    expect(Shore::VERSION).not_to be_nil
  end

  describe '.with_authorization' do
    let(:auth_header) { 'Bearer abcde.fghij.jlmnoi' }

    it 'sets the auth header thread locally for the duration of the block' do
      Shore.with_authorization(auth_header) do
        expect(Shore.authorization).to eq(auth_header)
      end
      expect(Shore.authorization).to be_nil
    end
  end
end
