class Admin::TagsController < Admin::ApplicationController
  decorates_assigned :tags, with: Admin::TagDecorator
  before_action :find_tag, only: [:update, :destroy, :edit]

  decorates_assigned :tags, with: Admin::TagDecorator

  add_breadcrumb :tags, path: proc { admin_tags_path }, with: [:new, :create]

  def index
    @search = TagFilter.new(params[:tag_filter])
    relation = Qa::Tag.order(id: :desc).where(page_size_params.to_h)

    @tags = @search.apply(relation)
  end

  def new
    @tag_form = Admin::TagForm.new(is_published: true, weight: 100)
  end

  def create
    @tag_form = Admin::TagForm.new
    save(:create)
  end

  def edit
    @tag_form = Admin::TagForm.from_tag(@tag)
    add_breadcrumb(@tag.name)
  end

  def update
    @tag_form = Admin::TagForm.new
    add_breadcrumb(@tag.name)
    save(:update)
  end

  def search
    tags = Qa::Tag.search(params[:search])
    render json: tags.map { |t| { id: t.id, name: t.name } }
  end

  def report
    tags = Qa::Tag.get_collection(
      'reports/tags',
      year: params.dig(:report, :year),
      month: params.dig(:report, :month)
    )
    content = Builder::CSV::Tag.new(tags).generate_line(
      [:name, :questions_counter, :answers_counter],
      [nil, t('activemodel.models.question'), t('activemodel.models.answer')]
    )
    send_data content, filename: report_name, type: :csv
  end

  private

  def report_name(extension = '.csv')
    filename = ['report', params.dig(:report, :year), params.dig(:report, :month)].compact.join('-')
    "#{filename}#{extension}"
  end

  def find_tag
    @tag ||= Qa::Tag.find(params[:id])
    raise Admin::NotFoundError unless @tag
    @tag
  end

  def tag_params
    params.require(:tag_form).permit(
      :id, :name, :slug, :weight, :is_published,
      seo_attributes: [:id, :title, :keywords, :description],
      image_attributes: [
        :id, :imageable_id, :imageable_type, :image, :image_cache
      ],
      linked_tag_ids: []
    )
  end

  def save(event = :create)
    @tag_form.assign_attributes(tag_params)

    if @tag_form.save
      SearchIndexJob.perform(@tag_form.id, type: 'tags', event: event.to_s)
      redirect_to_success edit_admin_tag_path(@tag_form.id)
    else
      render_fail @tag_form
    end
  end
end
