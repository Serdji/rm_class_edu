class QuestionFilter < BaseFilter
  ACCESSORS = %i(
    without_answers without_best_answer only_interesting_questions
    with_complaints states title user_type
  ).freeze

  attr_accessor(*ACCESSORS)

  class << self
    def user_types
      { fake: 'Вопросы отличников', real: 'Вопросы учеников' }.invert.to_a
    end
  end

  check_box_attributes :without_answers, :without_best_answer,
                       :only_interesting_questions, :with_complaints

  def apply(relation)
    ACCESSORS.each { |name| send "apply_#{name}" }
    relation.where(filter: result, include: 'user')
  end

  private

  def normalize_attributes!(attributes)
    attributes[:states] ||= []
    attributes[:states].reject!(&:blank?)
  end

  def apply_without_answers
    result[:answers_counter] = 0 if without_answers?
  end

  def apply_without_best_answer
    result[:has_best_answer] = false if without_best_answer?
  end

  def apply_only_interesting_questions
    result[:is_interesting] = true if only_interesting_questions?
  end

  def apply_with_complaints
    result[:has_complaints] = true if with_complaints?
  end

  def apply_states
    result[:state] = states if states.any?
  end

  def apply_title
    result[:title] = title if title.present?
  end

  def apply_user_type
    result['with_user'] = true if fake_users? || real_users?
    result['users.is_fake'] = true if fake_users?
    result['users.is_fake'] = false if real_users?
  end

  def fake_users?
    user_type == 'fake'
  end

  def real_users?
    user_type == 'real'
  end
end
