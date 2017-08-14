class Admin::AnswerDecorator < Draper::Decorator
  include HumanDates

  delegate_all

  def state
    super.inquiry
  end

  def safe_title
    str = h.strip_tags(object.body).truncate(110)
    str.present? ? str : "Ответ N #{id}"
  end

  def human_state_name
    I18n.t(state, scope: 'states.answer')
  end

  def has_complaints?
    !complaints.empty?
  end
end
