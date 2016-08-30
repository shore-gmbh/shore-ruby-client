RSpec.describe Shore::Tokens::V1::MerchantAccount do
  let!(:admin) { admin_merchant }
  let!(:member) { member_merchant }
  let!(:owner) { owner_merchant }
  let(:roles) { [admin, owner, member] }
  let(:id) { '74eb402b-e159-4027-9363-60772e6e8930' }
  let(:name) { 'Bob Barker' }
  let(:organization_id) { 'ede50446-d9c4-49d3-ae84-e0f468ee7ddb' }
  let(:attributes) do
    { name: name, organization_id: organization_id, roles: roles }
  end

  describe '#parse' do
    let!(:payload) do
      {
        id: id,
        version: 1,
        type: 'ma',
        data: {
          name: name,
          organization_id: urlsafe_uuid(organization_id),
          admin: [urlsafe_uuid(admin[:id])],
          owner: [urlsafe_uuid(owner[:id])],
          member: [urlsafe_uuid(member[:id])]
        }
      }
    end

    it 'loads the payload' do
      result = described_class.parse(payload)
      expect(result.owners).to include(owner[:id])
      expect(result.admins).to include(admin[:id])
      expect(result.members).to include(member[:id])
      expect(result.type).to eq('ma')
      expect(result.version).to eq(1)
      expect(result.id).to eq(id)
      expect(result.name).to eq(name)
      expect(result.organization_id).to eq(organization_id)
    end
  end

  describe 'Constructor' do
    subject { described_class.new(id, attributes) }

    it 'loads the merchants from the roles array' do
      expect(subject.admins).to include(admin[:id])
      expect(subject.members).to include(member[:id])
      expect(subject.owners).to include(owner[:id])
    end
  end

  describe '.as_json' do
    subject { described_class.new(id, attributes).as_json }

    it 'builds a proper jwt payload' do
      expect(subject).to match(
        name: name,
        organization_id: urlsafe_uuid(organization_id),
        owner: [urlsafe_uuid(owner[:id])],
        admin: [urlsafe_uuid(admin[:id])],
        member: [urlsafe_uuid(member[:id])]
      )
    end
  end

  describe '.role' do
    subject { described_class.new(id, attributes) }

    specify { expect(subject.role(admin[:id])).to eq('admin') }
    specify { expect(subject.role(owner[:id])).to eq('owner') }
    specify { expect(subject.role(member[:id])).to eq('member') }
    specify { expect(subject.role(SecureRandom.uuid)).to eq(nil) }
  end

  describe '.roles' do
    let(:bad_id) { SecureRandom.uuid }

    subject { described_class.new(id, attributes) }

    it 'returns hash of roles by id' do
      expect(subject.roles([admin[:id], owner[:id], bad_id])).to match(
        admin[:id] => 'admin',
        owner[:id] => 'owner',
        bad_id => nil
      )
    end
  end

  describe '.merchant_uuids' do
    subject { described_class.new(id, attributes) }

    it 'returns list of Merchants the MerchantAccount can access' do
      expect(subject.merchant_uuids).to contain_exactly(
        admin[:id], owner[:id], member[:id]
      )
    end
  end

  describe '.merchant_account' do
    subject { described_class.new(id, attributes) }

    it 'returns shore client resource' do
      expect(subject.merchant_account.id).to eq id
      expect(subject.merchant_account.type).to eq 'merchant_accounts'
    end
  end
end
