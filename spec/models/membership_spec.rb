require 'rails_helper'

RSpec.describe Membership do
  let(:membership) { create(:membership) }

  subject { membership }

  describe 'has valid associations' do
    it { is_expected.to belong_to(:role) }
    it { is_expected.to belong_to(:rolable) }

    it { is_expected.to be_valid }
  end
end
