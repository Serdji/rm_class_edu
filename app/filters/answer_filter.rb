class AnswerFilter < BaseFilter
  ACCESSORS = %i(
    states title question_id user_type with_complaints without_best_answer
  ).freeze

  attr_accessor(*ACCESSORS)

  check_box_attributes :without_best_answer, :with_complaints

  class << self
    def user_types
      { fake: 'Ответы отличников', real: 'Ответы учеников' }.invert.to_a
    end
  end

  def apply(relation)
    ACCESSORS.each { |name| send "apply_#{name}" }
    relation.where(filter: result)
  end

  def normalize_attributes!(attributes)
    attributes[:states] ||= []
    attributes[:states].reject!(&:blank?)
  end

  def apply_states
    result[:state] = states if states.any?
  end

  def apply_question_id
    result[:question_id] = question_id if question_id.present?
  end

  def apply_user_type
    result['with_user'] = true
    result['users.is_fake'] = true if fake_users?
    result['users.is_fake'] = false if real_users?
  end

  def apply_with_complaints
    result[:has_complaints] = true if with_complaints?
  end

  def apply_without_best_answer
    result[:best_answer] = false if without_best_answer?
  end

  def apply_title
    result[:body] = title.strip if title.present?
  end

  def fake_users?
    user_type == 'fake'
  end

  def real_users?
    user_type == 'real'
  end
end
