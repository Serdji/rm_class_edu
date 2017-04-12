require 'rails_helper'

RSpec.describe Version do
  let(:version) { create(:version) }

  subject { version }

  describe 'has valid associations' do
    it { is_expected.to belongs_to(:employee) }

    it { is_expected.to be_valid }
  end
end
