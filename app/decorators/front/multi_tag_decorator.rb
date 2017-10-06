class Front::MultiTagDecorator < Draper::Decorator
  include HumanDates
  delegate_all

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

  def tag
    tags.first
  end

  def name
    tags.select(&:is_published).map(&:name).join(', ')
  end

  def published?
    is_published?
  end
end
