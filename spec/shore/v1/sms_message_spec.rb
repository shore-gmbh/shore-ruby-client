RSpec.describe Shore::V1::SmsMessage do
  include_examples 'shore json api client' do
    let(:url) { 'https://api.shore.com/v1/sms_messages' }
  end
end
