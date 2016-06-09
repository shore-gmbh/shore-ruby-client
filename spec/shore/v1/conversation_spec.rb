require 'shore/v1'

RSpec.describe Shore::V1::Conversation do
  include_examples 'shore json api client' do
    let(:site) { 'https://shore-messaging-production.herokuapp.com/v1' }
  end
end
