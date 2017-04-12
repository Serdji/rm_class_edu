class Admin::AnswersController < Admin::ApplicationController
  before_action :find_answer, only: [:update, :edit, :complaints]

  decorates_assigned :answers, :answer, with: Admin::AnswerDecorator
  decorates_assigned :question, with: Admin::QuestionDecorator

  add_breadcrumb :answers, path: proc { admin_answers_path }

  def index
    @answers = Qa::Answer.order(created_at: :desc).where(prepare_filtering_params)
  end

  def edit
    @question = @answer.question
    add_breadcrumb answer.safe_title
  end

  def update
    save
  end

  def complaints; end

  private

  # TODO: move this logic from controller
  def prepare_filtering_params
    filtering = page_size_params

    if filtering.key?(:filter)
      filtering[:filter].each do |name, value|
        filtering[:filter][name] = value.reject!(&:empty?) if value.is_a? Array
      end
    end

    filtering.permit!.to_h
  end

  def find_answer
    @answer = Qa::Answer.find(params[:id], include: 'complaints')
    raise Admin::NotFoundError unless @answer
  end

  def answer_params
    params.require(:answer).permit(:body, :state, :best_answer)
  end

  def save
    @answer.assign_attributes(answer_params.to_h)

    if @answer.save
      enqueue_search_jobs
      redirect_to_success edit_admin_answer_path(@answer)
    else
      render_fail @answer
    end
  end

  def enqueue_search_jobs
    question = @answer.question
    SearchIndexJob.perform(question.id, type: 'questions', event: 'update')
    question.tags.each { |tag| SearchIndexJob.perform(tag.id, type: 'tags', event: 'update') }
  end
end
