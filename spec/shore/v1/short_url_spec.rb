# frozen_string_literal: true

RSpec.describe Shore::V1::ShortURL do
  include_examples 'shore json api client' do
    let(:url) { 'https://api.shore.com/v1/short_urls' }
  end
end
