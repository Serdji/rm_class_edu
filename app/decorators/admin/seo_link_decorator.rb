class Admin::SeoLinkDecorator < Draper::Decorator
  include HumanDates

  delegate_all
end
