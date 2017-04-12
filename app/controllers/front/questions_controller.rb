class Front::QuestionsController < Front::ApplicationController
  before_action :authenticate_user!, only: [:create, :update]

  before_action :check_question, only: :show

  helper_method :questions_facade

  def show
  end

  def create
    @question = Qa::Question.new(seo_attributes: {})
    session.delete 'first_question'
    save
  end

  private

  def questions_facade
    @questions_facade ||= Front::QuestionsFacade.new(self)
  end

  def check_question
    question = questions_facade.question
    raise Front::NotFoundError unless question && question.published?
  end

  def question_params
    params.require(:question).permit(
      :title, :body, image_ids: [], tag_ids: []
    ).merge(user_id: current_user.id)
  end

  def save
    @question.assign_attributes(question_params.to_h)
    @question.save

    if @question.response_errors.any?
      render json: @question.response_errors, status: :unprocessable_entity
    else
      question = Front::QuestionDecorator.decorate(@question)
      enqueue_search_jobs(question)
      render json: { url: question.path }
    end
  end

  def enqueue_search_jobs(question)
    SearchIndexJob.perform(question.id, type: 'questions', event: 'create')
    question.tags.each { |tag| SearchIndexJob.perform(tag.id, type: 'tags', event: 'update') }
  end
end
