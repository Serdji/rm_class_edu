class Front::TagsFacade
  SIMILAR_TAGS_LIMIT       = 4
  PER_PAGE_QUESTIONS_LIMIT = 20
  PER_PAGE_TAGS_LIMIT      = 20

  delegate :params, to: :@controller

  def initialize(controller)
    @controller = controller
  end

  def tags
    @tags ||= begin
      options = {
        has_questions: true, sort: '-weight',
        page: { number: params[:page], size: PER_PAGE_TAGS_LIMIT }
      }
      collection = View::Qa::Tag.get('tags', options).includes(:seo, :image)
      Front::TagDecorator.decorate_collection(collection)
    end
  end

  def tag_pages
    @tag_pages ||= begin
      collection = TagPage.order(:placement_index)
                          .paginate(page: params[:page], per_page: PER_PAGE_TAGS_LIMIT).qa_build
      Front::TagPageDecorator.decorate_collection(collection)
    end
  end

  def metapage
    @metapage ||= Metapage.qa.find_by(label: 'Темы')
  end

  def discussing_questions
    @discussing_questions ||= begin
      options = { include: 'tags,user', page: { size: 4 } }
      collection = View::Qa::Question.get("tags/#{tag.id}/discussing_questions", options)
                                     .includes(:seo)
      Front::QuestionDecorator.decorate_collection(collection)
    end
  end

  def tag_questions
    @tag_questions ||= questions("tags/#{tag.id}/questions")
  end

  def multi_tag_questions
    @multi_tag_questions ||= questions("multi_tags/#{multi_tag.id}/questions")
  end

  def similar_tags
    @similar_tags ||= similar(tag.id)
  end

  def similar_multi_tags
    @similar_multi_tags ||= similar(multi_tag.tags.first.id)
  end

  def tag
    @tag ||= begin
      tag = View::Qa::Tag.get "tags/slug/#{params[:slug]}"
      Front::TagDecorator.decorate(tag)
    end
  end

  def multi_tag
    @multi_tag ||= begin
      multi_tag = View::Qa::MultiTag.get "multi_tags/slug/#{params[:slug]}", include: 'tags'
      Front::MultiTagDecorator.decorate(multi_tag)
    end
  end

  private

  def similar(tag_id)
    options = { page: { size: SIMILAR_TAGS_LIMIT }, has_questions: true }
    collection = View::Qa::Tag.get("tags/#{tag_id}/similar_tags", options).includes(:seo, :image)
    Front::TagDecorator.decorate_collection(collection)
  end

  def questions(query)
    options = {
      page: { size: PER_PAGE_QUESTIONS_LIMIT, number: params[:page] },
      include: 'tags,user', sort: '-questions.created_at',
      filter: { state: Qa::Question::PUBLIC_STATES }
    }
    collection = View::Qa::Question.get(query, options).includes(:seo)
    Front::QuestionDecorator.decorate_collection(collection)
  end

  def decorator(t)
    "Front::#{t.tagable_type.demodulize}Decorator".safe_constantize
  end
end
