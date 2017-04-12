class Admin::QuestionsController < Admin::ApplicationController
  decorates_assigned :questions, with: Admin::QuestionDecorator

  before_action :find_question, only: [:update, :edit, :complaints]
  before_action :instantiate_question, only: [:new, :create]

  add_breadcrumb :questions, path: proc { admin_questions_path }, with: [:new, :create]

  def index
    @search = QuestionFilter.new(params[:question_filter])
    relation = Qa::Question.order(id: :desc).where(page_size_params.to_h)

    @questions = @search.apply(relation)
  end

  def edit
    add_breadcrumb(@question.title)
  end

  def update
    add_breadcrumb(@question.title)
    save
  end

  def complaints; end

  private

  def find_question
    @question = Qa::Question.find(params[:id], include: 'user,tags,complaints')
    raise Admin::NotFoundError unless @question
  end

  def instantiate_question
    @question = Qa::Question.new title: '', body: '', tags: []
  end

  def question_params
    params.require(:question).permit(
      :title, :body, :slug, :state, :is_interesting,
      seo_attributes: [:title, :description, :keywords], tag_ids: []
    )
  end

  def save
    @question.assign_attributes(question_params.to_h)

    if @question.save
      enqueue_search_jobs
      redirect_to_success edit_admin_question_path(@question)
    else
      render_fail @question
    end
  end

  def enqueue_search_jobs
    SearchIndexJob.perform(@question.id, type: 'questions', event: 'update')
    @question.tags.each { |tag| SearchIndexJob.perform(tag.id, type: 'tags', event: 'update') }
  end
end
