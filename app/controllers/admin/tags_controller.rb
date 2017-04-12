class Admin::TagsController < Admin::ApplicationController
  decorates_assigned :tags, with: Admin::TagDecorator
  before_action :find_tag, only: [:update, :destroy, :edit]

  add_breadcrumb :tags, path: proc { admin_tags_path }, with: [:new, :create]

  def index
    @tags = Qa::Tag.where(page_size_params.to_h)
  end

  def new
    @tag = Qa::Tag.new name: '', slug: '', weight: 100, is_published: true, linked_tags: []
  end

  def create
    @tag = Qa::Tag.new name: '', slug: '', weight: 100, is_published: true, linked_tags: []
    save(:create)
  end

  def edit
    add_breadcrumb(@tag.name)
  end

  def update
    add_breadcrumb(@tag.name)
    save(:update)
  end

  def search
    tags = Qa::Tag.search(params[:search])
    render json: tags.collect { |t| { id: t.id, name: t.name } }
  end

  private

  def find_tag
    @tag = Qa::Tag.find(params[:id], include: 'image')
    raise Admin::NotFoundError unless @tag
  end

  def tag_params
    params.require(:tag).permit(
      :id, :name, :slug, :weight, :is_published,
      seo_attributes: [:title, :keywords, :description],
      image_attributes: [:id, :imageable_id, :imageable_type, :image],
      linked_tag_ids: []
    )
  end

  def save(event = nil)
    @tag.assign_attributes(build_attributes.to_h)

    if @tag.valid? && @tag.save
      SearchIndexJob.perform(@tag.id, type: 'tags', event: event.to_s)
      redirect_to_success edit_admin_tag_path(@tag)
    else
      render_fail @tag
    end
  end

  def build_attributes
    attributes = tag_params
    image = attributes.dig(:image_attributes, :image)

    if image
      file = Faraday::UploadIO.new(image.path, 'image/jpeg')
      attributes[:image_attributes][:image] = file
    end

    attributes
  end
end
