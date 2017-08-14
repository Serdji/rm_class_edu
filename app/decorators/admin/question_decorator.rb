class Admin::QuestionDecorator < Draper::Decorator
  include HumanDates

  delegate_all

  def state
    super.inquiry
  end

  def safe_title
    h.strip_tags(object.title).truncate(110)
  end

  def human_state_name
    I18n.t(state, scope: 'states.question')
  end

  def has_complaints?
    !complaints.empty?
  end
end
