# frozen_string_literal: true

RSpec.describe Shore::V1::Participant do
  include_examples 'shore json api client' do
    let(:url) { 'https://api.shore.com/v1/participants' }
  end
end
