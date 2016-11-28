RSpec.describe Shore::V1::Conversation do
  include_examples 'shore json api client' do
    let(:url) { 'https://api.shore.com/v1/conversations' }
  end
end
