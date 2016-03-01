RSpec.describe Shore::Client::Tokens::MerchantRole do
  let(:merchant_role_attributes) { merchant_role }

  it 'creates merchant role instance' do
    merchant_role = described_class.new(merchant_role_attributes)
    expect(merchant_role.attributes).to eq(merchant_role_attributes)
  end
end
