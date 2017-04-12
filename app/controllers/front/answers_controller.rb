class Front::AnswersController < Front::ApplicationController
  before_action :authenticate_user!, only: [:create, :make_best]

  before_action :find_question, only: :create
  before_action :find_answer, only: :make_best

  def create
    @answer = Qa::Answer.new(question_id: params[:question_id])
    save
  end

  def make_best
    question = Qa::Question.find(@answer.question_id, include: 'tags,taggings')
    @answer.make_best! if current_user.is_sentry && !question.has_best_answer?

    result = if current_user.is_sentry && !question.has_best_answer?
               @answer.make_best!
               path = Front::QuestionDecorator.decorate(question).path
               { success: true, url: path }
             else
               { success: false }
             end

    render json: result
  end

  private

  def safe_params
    params.require(:answer).permit(:body, image_ids: [])
  end

  def save
    attributes = safe_params.merge(user_id: current_user.id)

    @answer.assign_attributes(attributes.to_h)
    @answer.save

    if @answer.response_errors.any?
      render json: @answer.response_errors, status: :unprocessable_entity
    else
      enqueue_search_jobs
      render json: @answer
    end
  end

  def find_question
    @question = Qa::Question.find(params[:question_id])
  end

  def find_answer
    @answer = Qa::Answer.find(params[:id])
  end

  def enqueue_search_jobs
    SearchIndexJob.perform(@question.id, type: 'questions', event: 'create')
    @question.tags.each { |tag| SearchIndexJob.perform(tag.id, type: 'tags', event: 'update') }
  end
end
