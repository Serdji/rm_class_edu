class Admin::MultiTagDecorator < Draper::Decorator
  include HumanDates

  delegate_all

  def title
    tags.map(&:name).join(', ')
  end
end
