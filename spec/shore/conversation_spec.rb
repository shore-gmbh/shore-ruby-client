RSpec.describe Shore::Conversation do
  include_examples 'shore json api client' do
    let(:site) { 'https://api.shore.com/v1' }
  end
end