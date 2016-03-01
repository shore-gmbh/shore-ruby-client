RSpec.describe Shore::Client::Tokens::MerchantAccount do
  let(:role_id) { '74eb402b-e159-4027-9363-60772e6e8930' }
  let(:role_slug) { 'achsel-alex' }
  let(:role_name) { 'member' }
  let(:merchant_account_attributes) do
    {
      'id' => '226fc766-3cf0-4d18-a988-5f8235f17edb',
      'type' => 'merchant-accounts',
      'attributes' => {
        'name' => 'Bob Barker',
        'roles' => [
          {
            'id' => role_id,
            'type' => 'merchants',
            'slug' => role_slug,
            'name' => 'Achsel Alex',
            'role' => role_name
          }
        ]
      }
    }.with_indifferent_access
  end

  describe '.as_json' do
    it 'creates merchant role instance' do
      merchant_account = described_class.new(merchant_account_attributes)
      expect(merchant_account.as_json).to eq(merchant_account_attributes)
    end
  end

  describe '.role' do
    it 'returns the role name by id' do
      merchant_account = described_class.new(merchant_account_attributes)
      expect(merchant_account.role(role_id))
        .to eq(role_name)
    end
  end

  describe '.role' do
    it 'returns the role name by slug' do
      merchant_account = described_class.new(merchant_account_attributes)
      expect(merchant_account.role(role_slug))
        .to eq(role_name)
    end
  end
end
