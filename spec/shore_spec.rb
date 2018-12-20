# frozen_string_literal: true

RSpec.describe Shore do
  it 'has a version number' do
    expect(Shore::VERSION).not_to be_nil
  end

  describe '.with_authorization' do
    let(:auth_header) { 'Bearer abcde.fghij.jlmnoi' }

    after { Shore.authorization = nil }

    it 'sets the auth header thread locally for the duration of the block' do
      Shore.with_authorization(auth_header) do
        expect(Shore.authorization).to eq(auth_header)
      end
      expect(Shore.authorization).to be_nil
    end

    it 'keeps the initial auth header after the block call' do
      Shore.authorization = 'Bearer old.token'

      Shore.with_authorization(auth_header) do
        expect(Shore.authorization).to eq(auth_header)
      end

      expect(Shore.authorization).to eq('Bearer old.token')
    end
  end
end
