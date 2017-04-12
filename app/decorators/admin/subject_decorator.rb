class Admin::SubjectDecorator < Draper::Decorator
  include HumanDates
  include ObjectPublished

  delegate_all
end
