class QuestionFilter < BaseFilter
  class << self
    # TODO: may be move this to normalize
    def check_box_attributes(*names)
      names.each do |name|
        define_method("#{name}?") do
          send(name) == '1'
        end
      end
    end
  end

  attr_accessor :without_answers, :without_best_answer, :states, :title

  check_box_attributes :without_answers, :without_best_answer

  def apply(relation)
    result = {}

    result[:has_best_answer] = false if without_best_answer?
    result[:answers_counter] = 0 if without_answers?
    result[:state] = states if states.any?
    result[:title] = title

    relation.where(filter: result)
  end

  private

  def normalize_attributes!(attributes)
    attributes[:states] ||= []
    attributes[:states].reject!(&:blank?)
  end
end
