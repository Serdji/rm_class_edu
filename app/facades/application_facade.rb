class ApplicationFacade
  DISCUSSING_LIMIT = 4
  SEO_LINKS_LIMIT = 10
  POPULAR_LIMIT = 6

  def initialize(controller)
    @controller = controller
  end

  def interesting_questions
    @interesting_questions ||= begin
      options = {
        include: 'tags,taggings',
        filter: { is_interesting: true, state: Qa::Question::PUBLIC_STATES },
        page: { size: POPULAR_LIMIT }, sort: '-questions.answers_counter'
      }

      collection = View::Qa::Question.get('questions', options)
      Front::QuestionDecorator.decorate_collection(collection)
    end
  end

  def most_discussing_questions
    @discussing_questions ||= begin
      options = { include: 'tags,taggings', page: { size: DISCUSSING_LIMIT } }
      collection = View::Qa::Question.get('questions/most_discussing', options)
      Front::QuestionDecorator.decorate_collection(collection)
    end
  end

  def most_discussing_tags
    @discussing_tags ||= begin
      options = { page: { size: DISCUSSING_LIMIT }, has_questions: true }
      collection = View::Qa::Tag.get('tags/most_discussing', options)
      Front::TagDecorator.decorate_collection(collection)
    end
  end

  def today_discussing_tags
    @today_discussing_tags ||= begin
      options = { page: { size: DISCUSSING_LIMIT } }
      collection = View::Qa::Tag.get('tags/most_discussing_per_day', options)
      Front::TagDecorator.decorate_collection(collection)
    end
  end

  def seo_links
    @seo_links ||= SeoLink.limit(SEO_LINKS_LIMIT)
  end

  def new_complaint
    Qa::Complaint.new
  end
end
