require 'spec_helper'

describe Shore::Client::Tokens::MerchantRole do
  let(:merchant_role_attributes) do
    {
      id: '74eb402b-e159-4027-9363-60772e6e8930',
      type: 'merchants',
      slug: 'achsel-alex',
      name: 'Achsel Alex',
      role: 'member'
    }.with_indifferent_access
  end

  it 'creates merchant role instance' do
    merchant_role = described_class.new(merchant_role_attributes)
    expect(merchant_role.attributes).to eq(merchant_role_attributes)
  end
end
