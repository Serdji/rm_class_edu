require 'rails_helper'

RSpec.describe Admin::EmployeeDecorator do
  let(:employee) { Admin::EmployeeDecorator.new(create(:employee)) }

  describe '#name' do
    it 'return full name of employee' do
      expect(employee.name).to match("#{employee.first_name} #{employee.last_name}")
    end
  end

  describe '#name_with_email' do
    it 'return full name and email of employee' do
      expected = "#{employee.first_name} #{employee.last_name} (#{employee.email})"
      expect(employee.name_with_email).to match(expected)
    end
  end
end
