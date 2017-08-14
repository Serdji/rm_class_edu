class Front::SearchController < Front::ApplicationController
  helper_method :search_facade
  helper_method :questions_active?, :tags_active?

  before_action :check_query, only: :serp

  def suggest
    result = SearchService.suggest(params[:query])
    render json: result
  end

  def serp
    options = { type: search_type, page: params[:page], is_published: true }
    @search_result = SearchService.search(params[:query], options)
  end

  private

  def search_facade
    @search_facade ||= Front::SearchFacade.new
  end

  def search_type
    %w(tags questions).include?(params[:type]) ? params[:type] : 'questions'
  end

  def questions_active?
    !tags_active?
  end

  def tags_active?
    params[:type] == 'tags'
  end

  def check_query
    query = params[:query]
    raise ActionController::RoutingError, query unless query.is_a?(String)
  end
end
