RSpec.describe Shore::Feedback do
  include_examples 'shore json api client' do
    let(:url) { 'https://api.shore.com/v1/feedbacks' }
  end
end
