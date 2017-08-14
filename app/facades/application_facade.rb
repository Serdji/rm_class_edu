class ApplicationFacade
  DISCUSSING_LIMIT = 4
  SEO_LINKS_LIMIT = 10
  POPULAR_LIMIT = 6

  def initialize(controller)
    @controller = controller
  end

  def tag_menu
    @tag_menu ||= TagMenu.menu
  end

  def interesting_questions
    @interesting_questions ||= begin
      options = {
        include: 'tags',
        filter: { is_interesting: true, state: Qa::Question::PUBLIC_STATES },
        page: { size: POPULAR_LIMIT }, sort: '-questions.answers_counter'
      }

      collection = View::Qa::Question.get('questions', options).includes(:seo)
      Front::QuestionDecorator.decorate_collection(collection)
    end
  end

  def most_discussing_questions
    @discussing_questions ||= begin
      options = {
        from: Date.current - 7.days, limit: DISCUSSING_LIMIT, include: 'tags'
      }
      collection = View::Qa::Question.get('questions/most_discussing', options).includes(:seo)
      Front::QuestionDecorator.decorate_collection(collection)
    end
  end

  def most_discussing_tags
    @discussing_tags ||= discussing_tags(from: Date.current - 7.days)
  end

  def today_discussing_tags
    @today_discussing_tags ||= discussing_tags(from: Date.current - 1.day)
  end

  def seo_links
    @seo_links ||= SeoLink.limit(SEO_LINKS_LIMIT)
  end

  def new_complaint
    Qa::Complaint.new
  end

  private

  def discussing_tags(from:, to: Date.current)
    options = { from: from, to: to, limit: DISCUSSING_LIMIT, has_questions: true }
    collection = View::Qa::Tag.get('tags/most_discussing', options).includes(:seo, :image)
    Front::TagDecorator.decorate_collection(collection)
  end
end
