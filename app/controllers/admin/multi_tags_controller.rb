class Admin::MultiTagsController < Admin::ApplicationController
  decorates_assigned :multi_tags, :multi_tag, with: Admin::MultiTagDecorator
  add_breadcrumb :multi_tags,
                 path: proc { admin_multi_tags_path },
                 with: [:new, :create, :destroy]

  before_action :find_multi_tag, only: [:edit, :update, :destroy]
  before_action :build_multi_tag, only: [:new, :create]

  def index
    @multi_tags = Qa::MultiTag.order(id: :desc).where(page_size_params.merge(include: 'tags').to_h)
  end

  def new; end

  def create
    save do
      @multi_tag.create_seo(multi_tag_params[:seo_attributes])
    end
  end

  def edit
    add_breadcrumb(multi_tag.title)
  end

  def update
    add_breadcrumb(multi_tag.title)
    save do
      @multi_tag.seo.update_attributes(multi_tag_params[:seo_attributes])
    end
  end

  def destroy
    @multi_tag.destroy
    @multi_tag.seo.destroy
    TagPagesService.recreate
    redirect_to admin_multi_tags_path, success: t('flashes.destroy.success')
  end

  private

  def find_multi_tag
    @multi_tag ||= Qa::MultiTag.find(params[:id], include: 'tags')
    raise Admin::NotFoundError unless @multi_tag
    @multi_tag
  end

  def build_multi_tag
    @multi_tag = Qa::MultiTag.new slug: '', tag_ids: []
    @multi_tag.build_seo
  end

  def multi_tag_params
    params.require(:multi_tag).permit(
      :slug,
      seo_attributes: [:title, :description, :keywords],
      tag_ids: []
    )
  end

  def save
    @multi_tag.assign_attributes(multi_tag_params.to_h)

    if @multi_tag.valid? && @multi_tag.save
      yield if block_given?
      TagPagesService.recreate
      redirect_to_success edit_admin_multi_tag_path(@multi_tag)
    else
      render_fail @multi_tag
    end
  end
end
