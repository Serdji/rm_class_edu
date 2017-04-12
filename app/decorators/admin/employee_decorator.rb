class Admin::EmployeeDecorator < Draper::Decorator
  include HumanDates

  delegate_all

  def name
    [first_name, last_name].compact.join(' ')
  end

  def name_with_email
    "#{name} (#{email})"
  end
end
