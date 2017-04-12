require 'rails_helper'

RSpec.describe Admin::RoleDecorator do
  let(:role) { Admin::RoleDecorator.new(create(:role, name: 'superuser')) }

  describe '#human_name' do
    it 'return russian name instead of enlish slug' do
      expect(role.human_name).to match('Администратор')
    end
  end
end
