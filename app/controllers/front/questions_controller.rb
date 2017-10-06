class Front::QuestionsController < Front::ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :create_user!, only: :create

  before_action :check_redirect, only: :show
  before_action :check_question, only: [:show, :redirect]

  helper_method :questions_facade

  def show; end

  def new
    return not_found_error if desktop_version?
  end

  def redirect
    # Redirect old fashion url of question without "temy-" prefix
    raise Front::NotFoundError if params['id'].to_i > 10_000
    redirect_to Front::QuestionDecorator.new(@question).path, status: 301
  end

  # rubocop:disable Metrics/AbcSize
  def create
    state = current_user.is_fake? ? :without_complaints : :fresh
    attributes = { seo_attributes: {}, state: state }

    @question = Qa::Question.new(attributes.merge(question_params.to_h))

    if @question.valid?
      check_captcha! if desktop_version?
      return if response_body.present?

      save
    else
      render json: @question.errors.messages, status: :unprocessable_entity
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def questions_facade
    @questions_facade ||= Front::QuestionsFacade.new(self)
  end

  def check_redirect
    question = questions_facade.question
    return unless question

    redirect_to question.redirect.redirect_path if question.redirect
  end

  def check_question
    @question = questions_facade.question
    raise Front::NotFoundError unless @question && @question.published?
  end

  def question_params
    params.require(:question).permit(
      :title, :body, image_ids: [], tag_ids: []
    ).merge(user_id: current_user.id)
  end

  def save
    if @question.save
      @question.link_with_images(question_params.dig(:image_ids))
      activity_limiter.store if desktop_version?

      question = Front::QuestionDecorator.decorate(@question)
      enqueue_search_jobs(question)

      render json: { url: question.path }
    else
      render json: @question.response_errors, status: :unprocessable_entity
    end
  end

  def enqueue_search_jobs(question)
    SearchIndexJob.perform(question.id, type: 'questions', event: 'create')
    question.tags.each { |tag| SearchIndexJob.perform(tag.id, type: 'tags', event: 'update') }
  end
end
