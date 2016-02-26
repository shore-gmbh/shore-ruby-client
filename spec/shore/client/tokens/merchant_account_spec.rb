require 'spec_helper'

describe Shore::Client::Tokens::MerchantAccount do
  let(:merchant_account_attributes) do
    {
      'id' => '226fc766-3cf0-4d18-a988-5f8235f17edb',
      'type' => 'merchant-accounts',
      'attributes' => {
        'name' => 'Bob Barker',
        'roles' => [
          {
            'id' => '74eb402b-e159-4027-9363-60772e6e8930',
            'type' => 'merchants',
            'slug' => 'achsel-alex',
            'name' => 'Achsel Alex',
            'role' => 'member'
          }
        ]
      }
    }.with_indifferent_access
  end

  describe '.as_json'
  it 'creates merchant role instance' do
    merchant_account = described_class.new(merchant_account_attributes)
    expect(merchant_account.as_json).to eq(merchant_account_attributes)
  end
end
