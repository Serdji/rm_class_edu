class Admin::TagDecorator < Draper::Decorator
  include HumanDates

  delegate_all
end
