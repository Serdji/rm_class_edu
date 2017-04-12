class Front::QuestionsFacade
  PER_PAGE_QUESTIONS_LIMIT = 20
  SIMILAR_QUESTIONS_LIMIT = 5
  SIMILAR_TAGS_LIMIT = 4

  delegate :params, to: :@controller

  def initialize(controller)
    @controller = controller
  end

  def questions
    @questions ||= begin
      options = {
        include: 'tags,taggings,user',
        page: { number: params[:page], size: PER_PAGE_QUESTIONS_LIMIT },
        filter: { state: ::Qa::Question::PUBLIC_STATES }, sort: '-ordered_at'
      }
      collection = View::Qa::Question.get('questions', options)
      Front::QuestionDecorator.decorate_collection(collection)
    end
  end

  def metapage
    @metapage ||= begin
      metapage = Metapage.qa.find_by(label: 'Ответы')
      Front::MetapageDecorator.decorate(metapage)
    end
  end

  def similar_questions
    @similar_questions ||= begin
      options = {
        only_published: true,
        page: { size: SIMILAR_QUESTIONS_LIMIT }, include: 'tags,taggings,user'
      }
      path = "questions/#{params[:id]}/similar_questions"
      collection = View::Qa::Question.get(path, options)
      Front::QuestionDecorator.decorate_collection(collection)
    end
  end

  def similar_tags
    @similar_tags ||= begin
      options = { page: { size: SIMILAR_TAGS_LIMIT }, include: 'image', has_questions: true }
      collection = View::Qa::Tag.get("questions/#{params[:id]}/similar_tags", options)
      Front::TagDecorator.decorate_collection(collection)
    end
  end

  def question
    @question ||= begin
      question = View::Qa::Question.get("questions/#{params[:id]}", include: 'tags,taggings,user')
      Front::QuestionDecorator.decorate(question) if question
    end
  end
end
