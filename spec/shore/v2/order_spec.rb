# frozen_string_literal: true

RSpec.describe Shore::V2::Order do
  include_examples 'shore json api client' do
    let(:url) { 'https://api.shore.com/v2/orders' }
  end
end
