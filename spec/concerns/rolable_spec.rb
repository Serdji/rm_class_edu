RSpec.shared_examples 'rolable' do
  let(:model) { FactoryGirl.create(described_class.name.underscore) }
  let(:role)  { FactoryGirl.create(:role) }

  describe '#has_role?' do
    context 'when role exists' do
      before do
        model.roles << role
      end

      it 'should return true' do
        expect(model.has_role?(role.name)).to be_truthy
      end
    end

    context 'when role does not exist' do
      it 'should return false' do
        expect(model.has_role?('not_exists')).to be_falsey
      end
    end
  end

  subject { model }

  describe 'has vaild associations' do
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:roles) }

    it { is_expected.to be_valid }
  end
end
