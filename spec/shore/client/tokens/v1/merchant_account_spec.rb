RSpec.describe Shore::Client::Tokens::V1::MerchantAccount do
  let!(:admin) { admin_merchant }
  let!(:member) { member_merchant }
  let!(:owner) { owner_merchant }
  let(:roles) { [admin, owner, member] }
  let(:id) { '74eb402b-e159-4027-9363-60772e6e8930' }
  let(:attributes) { { roles: roles } }

  describe '#parse' do
    let!(:payload) do
      {
        id: id,
        version: 1,
        type: 'merchant-account',
        data: {
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
      expect(result.type).to eq('merchant-account')
      expect(result.version).to eq(1)
      expect(result.id).to eq(id)
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
        a_hash_including(
          data: {
            owner: [urlsafe_uuid(owner[:id])],
            admin: [urlsafe_uuid(admin[:id])],
            member: [urlsafe_uuid(member[:id])]
          }
        )
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
end
