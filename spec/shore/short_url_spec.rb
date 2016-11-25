RSpec.describe Shore::ShortURL do
  include_examples 'shore json api client' do
    let(:url) { 'https://api.shore.com/v1/short_urls' }
  end
end
