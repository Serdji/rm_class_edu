require 'rails_helper'

RSpec.describe Admin::VersionDecorator do
  let(:version) { Admin::VersionDecorator.new(create(:version, event: 'update')) }

  describe '#human_employee' do
    it 'return employee human name' do
      expected = "#{version.employee.first_name} #{version.employee.last_name}"
      expect(version.human_employee).to match(expected)
    end
  end

  describe '#human_block' do
    it 'return human name of block' do
      expect(version.human_block).to match(version.item_type.constantize.model_name.human)
    end
  end

  describe '#human_event' do
    it 'return human name of event' do
      expect(version.human_event).to match('Редактирование')
    end
  end

  describe '#human_item' do
    it 'return human name of item' do
      author_name = [version.item.last_name, version.item.first_name].compact.join(' ')
      expect(version.human_item).to match(author_name)
    end
  end
end
