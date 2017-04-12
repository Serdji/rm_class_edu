class Front::SearchFacade
  QUESTIONS_LIMIT = 6
  TAGS_LIMIT = 12

  def fresh_questions
    @fresh_questions ||= begin
      questions = Qa::Question.where(
        filter: { has_best_answer: true, state: Qa::Question::PUBLIC_STATES },
        include: 'tags,taggings,user'
      ).order(created_at: :desc).limit(QUESTIONS_LIMIT)

      Front::QuestionDecorator.decorate_collection(questions)
    end
  end

  def most_answered_tags
    @most_answered_tags ||= begin
      tags = Qa::Tag.has_questions.where(include: 'image')
                    .order(answers_counter: :desc).limit(TAGS_LIMIT)

      Front::TagDecorator.decorate_collection(tags)
    end
  end
end
