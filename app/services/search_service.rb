class SearchService
  include Singleton

  DEFAULT_SIZE = 20

  class << self
    delegate :search, :index, :raw_search, :search_question, :search_tag, to: :instance
  end

  # TODO: remove this method
  def raw_search(query, options = {})
    search_connection.call(query, options).body
  end

  def index(data)
    if Rails.env.production?
      index_connection.call(data)
    else
      Rails.logger.info(data)
    end
  end

  def search(query, options = {})
    transform_pagination!(options)

    result = raw_search(query, options)
    Result.new(result, options.slice(:size, :from))
  end

  def search_question(query)
    search(query, type: :questions)
  end

  def search_tag(query)
    search(query, type: :tags)
  end

  private

  def search_connection
    @search_connection ||= SearchService::Connections::Search.new
  end

  def index_connection
    @index_conection ||= SearchService::Connections::Index.new
  end

  def transform_pagination!(options)
    page = [1, options.delete(:page).to_i].max

    size = options.delete(:per_page) || DEFAULT_SIZE
    from = (page - 1) * size

    options.merge!(size: size, from: from)
  end
end
