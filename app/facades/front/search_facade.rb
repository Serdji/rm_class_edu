class Front::SearchFacade
  QUESTIONS_LIMIT = 6
  TAGS_LIMIT = 12

  def fresh_questions
    @fresh_questions ||= begin
      options = {
        filter: { has_best_answer: true, state: ::Qa::Question::PUBLIC_STATES },
        include: 'tags,user', sort: '-questions.created_at',
        page: { size: QUESTIONS_LIMIT }
      }

      questions = View::Qa::Question.get('questions', options)
      Front::QuestionDecorator.decorate_collection(questions)
    end
  end

  def most_answered_tags
    @most_answered_tags ||= begin
      options = {
        has_questions: true,
        sort: '-answers_counter', page: { size: TAGS_LIMIT }
      }
      tags = View::Qa::Tag.get('tags', options)
      Front::TagDecorator.decorate_collection(tags)
    end
  end
end
