RSpec.describe Shore::V1::ComMerchantConfig do
  include_examples 'shore json api client' do
    let(:url) { 'https://api.shore.com/v1/com_merchant_configs' }
  end
end
