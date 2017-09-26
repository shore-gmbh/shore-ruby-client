# frozen_string_literal: true

RSpec.describe Shore::V2::Payment do
  include_examples 'shore json api client' do
    let(:url) { 'https://api.shore.com/v2/payments' }
  end
end
