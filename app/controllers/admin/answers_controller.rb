class Admin::AnswersController < Admin::ApplicationController
  before_action :find_answer, only: [:update, :edit, :complaints]

  decorates_assigned :answers, :answer, with: Admin::AnswerDecorator
  decorates_assigned :question, with: Admin::QuestionDecorator

  add_breadcrumb :answers, path: proc { admin_answers_path }

  def index
    relation = Qa::Answer.order('answers.created_at' => :desc).where(page_size_params.to_h)

    @search = AnswerFilter.new(params[:answer_filter])
    @answers = @search.apply(relation)
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

  def find_answer
    @answer ||= Qa::Answer.find(params[:id], include: 'complaints')
    raise Admin::NotFoundError unless @answer
    @answer
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
