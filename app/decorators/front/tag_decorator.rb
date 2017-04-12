class Front::TagDecorator < Draper::Decorator
  include HumanDates
  delegate_all

  delegate :url, to: :image, prefix: true, allow_nil: true

  def human_questions_counter
    [
      object.questions_counter,
      Qa::Question.model_name.human(count: object.questions_counter)
    ].join(' ')
  end

  def human_answers_counter
    [
      object.answers_counter,
      Qa::Answer.model_name.human(count: object.answers_counter)
    ].join(' ')
  end

  def published?
    is_published? && questions_counter > 0
  end
end
