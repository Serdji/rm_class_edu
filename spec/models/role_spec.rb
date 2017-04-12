require 'rails_helper'

RSpec.describe Role do
  let(:role) { create(:role) }

  subject { role }

  describe 'has valid associations' do
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:employees) }
    it { is_expected.to have_many(:users) }

    it { is_expected.to be_valid }
  end
end
