class Front::MultiTagsController < Front::ApplicationController
  before_action :check_tag, only: :show

  helper_method :tags_facade

  def show; end

  private

  def tags_facade
    @tags_facade ||= Front::TagsFacade.new(self)
  end

  def check_tag
    tag = tags_facade.multi_tag
    raise Front::NotFoundError unless tag
  end
end
