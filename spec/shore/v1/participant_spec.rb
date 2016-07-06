require 'shore/v1'

RSpec.describe Shore::V1::Participant do
  include_examples 'shore json api client' do
    let(:site) { 'https://api.shore.com/v1' }
  end
end
