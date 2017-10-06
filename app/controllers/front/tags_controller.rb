class Front::TagsController < Front::ApplicationController
  before_action :check_tag, only: :show

  helper_method :tags_facade

  def index; end

  def show; end

  def search
    options = {
      page: { size: 7 },
      filter: { is_published: true, name: params[:search] }
    }

    render json: tags(options)
  end

  def options
    options = {
      sort: '-weight',
      page: { size: 10 },
      filter: { is_published: true }
    }

    render json: tags(options)
  end

  private

  def tags_facade
    @tags_facade ||= Front::TagsFacade.new(self)
  end

  def check_tag
    tag = tags_facade.tag
    raise Front::NotFoundError unless tag && tag.published?
  end

  def tags(options)
    tags = View::Qa::Tag.get('tags', options).includes(:seo, :image)

    tags.map do |tag|
      { id: tag.id, name: tag.name, image: tag.image_thumb_24x24_url }
    end
  end
end
