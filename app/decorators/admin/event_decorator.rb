class Admin::EventDecorator < Draper::Decorator
  delegate_all

  def id
    object
  end

  def name
    h.t("events.#{object}")
  end
end
