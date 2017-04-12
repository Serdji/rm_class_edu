class ViewedQuestionsService < ViewedService
  LIMIT = 5
  KEY = 'viewed_questions'.freeze

  def collections
    ids = question_ids
    return [] unless ids.any?

    questions = Qa::Question.where(filter: { id: ids })

    questions.to_a.sort_by { |x| ids.index(x.id.to_i) }
  end
  alias questions collections
  alias question_ids collection_ids

  def key
    KEY
  end

  def limit
    LIMIT
  end
end
