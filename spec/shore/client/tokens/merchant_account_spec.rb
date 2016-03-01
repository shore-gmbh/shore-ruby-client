RSpec.describe Shore::Client::Tokens::MerchantAccount do
  let(:role_id) { '74eb402b-e159-4027-9363-60772e6e8930' }
  let(:role_slug) { 'achsel-alex' }
  let(:role_name) { 'member' }
  let(:roles) { [merchant_role(id: role_id, slug: role_slug, role: role_name)] }
  let(:merchant_account_attributes) do
    merchant_account(attributes: { roles: roles })
  end

  describe '.as_json' do
    it 'creates merchant role instance' do
      merchant_account = described_class.new(merchant_account_attributes)
      expect(merchant_account.as_json).to eq(merchant_account_attributes)
    end
  end

  describe '#role' do
    context 'with id' do
      it 'returns the role name' do
        merchant_account = described_class.new(merchant_account_attributes)
        expect(merchant_account.role(role_id))
          .to eq(role_name)
      end
    end

    context 'with slug' do
      it 'returns the role name' do
        merchant_account = described_class.new(merchant_account_attributes)
        expect(merchant_account.role(role_slug))
          .to eq(role_name)
      end
    end
  end
end
