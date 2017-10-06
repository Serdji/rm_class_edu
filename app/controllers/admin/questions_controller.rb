class Admin::QuestionsController < Admin::ApplicationController
  decorates_assigned :questions, with: Admin::QuestionDecorator

  before_action :find_question, only: [:update, :edit, :complaints]
  before_action :build_question, only: [:new, :create]

  add_breadcrumb :questions, path: proc { admin_questions_path }, with: [:new, :create]

  def index
    @search = QuestionFilter.new(params[:question_filter])
    relation = Qa::Question.order('questions.id' => :desc).where(page_size_params.to_h)

    @questions = @search.apply(relation).preload(:redirect, Redirect)
  end

  def edit
    add_breadcrumb(@question.title)
  end

  def update
    add_breadcrumb(@question.title)
    save do
      @question.seo.update_attributes(question_params[:seo_attributes])
    end
  end

  def complaints; end

  private

  def find_question
    options = { include: 'user,tags,complaints', filter: { is_interesting: true } }
    @question ||= Qa::Question.find(params[:id], options)
    raise Admin::NotFoundError unless @question
    @question
  end

  def build_question
    @question = Qa::Question.new title: '', body: '', tags: []
  end

  def question_params
    params.require(:question).permit(
      :title, :body, :slug, :state, :is_interesting,
      redirect_attributes: [:redirect_type, :redirect_id],
      seo_attributes: [:title, :description, :keywords],
      tag_ids: []
    )
  end

  def save
    @question.assign_attributes(question_params.to_h)

    if @question.valid? && @question.save && save_redirect
      yield if block_given?
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

  def redirect_params
    question_params[:redirect_attributes].to_h.delete_if { |_, v| v.blank? }
  end

  # TODO: move from controller
  # rubocop:disable Metrics/AbcSize
  def save_redirect
    return unless redirect_params.any?

    redirect = @question.redirect
    if redirect
      redirect.assign_attributes(redirect_params)
      redirect_params[:redirect_type] == 'destroy' ? redirect.destroy : redirect.save
    else
      return true if redirect_params[:redirect_type] == 'destroy'
      @question.build_redirect(redirect_params)
      @question.redirect.save
    end
  end
end
