class Front::AnswersController < Front::ApplicationController
  before_action :authenticate_user!, only: [:create, :make_best]
  before_action :create_user!, only: :create

  before_action :find_question, only: [:create, :new]
  before_action :find_answer, only: :make_best

  decorates_assigned :question, with: Front::QuestionDecorator

  def new
    @question = ::Qa::Question.find(params[:question_id], include: 'tags')
    raise Front::NotFoundError if desktop_version? || !@question
  end

  def create
    state = current_user.is_fake? ? :without_complaints : :fresh
    attributes = { question_id: params[:question_id], state: state }

    @answer = Qa::Answer.new(attributes.merge(answer_attributes))

    if @answer.valid?
      check_captcha! if desktop_version?
      return if response_body.present?

      save
    else
      render json: @answer.response_errors, status: :unprocessable_entity
    end
  end

  def make_best
    @question = Qa::Question.find(@answer.question_id, include: 'tags')

    if current_user.is_sentry && !question.has_best_answer?
      @answer.make_best!
      render json: { success: true, url: question.path }
    else
      render json: { success: false }
    end
  end

  private

  def safe_params
    params.require(:answer).permit(:body)
  end

  def answer_attributes
    safe_params.merge(user_id: current_user.id).to_h
  end

  def save
    if @answer.save
      @answer.link_with_images(params.dig(:answer, :image_ids))

      activity_limiter.store if desktop_version?
      enqueue_search_jobs

      render json: @answer
    else
      render json: @answer.response_errors, status: :unprocessable_entity
    end
  end

  def find_question
    @question = ::Qa::Question.find(params[:question_id])
  end

  def find_answer
    @answer = Qa::Answer.find(params[:id])
  end

  def enqueue_search_jobs
    SearchIndexJob.perform(@question.id, type: 'questions', event: 'update')
    @question.tags.each { |tag| SearchIndexJob.perform(tag.id, type: 'tags', event: 'update') }
  end
end
