class Admin::QuestionDecorator < Draper::Decorator
  include HumanDates

  delegate_all

  def state
    super.inquiry
  end

  def safe_title
    h.break_too_long_words(h.strip_tags(object.title).truncate(110))
  end

  def human_state_name
    I18n.t(state, scope: 'states.question')
  end
end
