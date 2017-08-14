qa_api = Rails.application.config_for(:qa_api)

options = {
  url: qa_api.fetch('domain'),
  headers: {
    'X-Api-Version' => qa_api.fetch('api_version'),
    'X-Api-Token' => qa_api.fetch('api_token')
  }
}

Her::API.setup(options) do |c|
  # Request
  c.use Faraday::Request::Multipart
  c.use Her::Middleware::AcceptJSON
  c.use Faraday::Request::UrlEncoded

  # Response
  c.use HerExt::Middlewares::JsonApiParser

  # Turn off cache for backend
  unless Socket.gethostname.include? 'back'
    cache_store = Education::Application.config.http_cache_store
    options = { logger: Rails.logger, shared_cache: false, serializer: Marshal }
    c.use Faraday::HttpCache, store: cache_store, **options
  end

  # Adapter
  c.use Faraday::Adapter::NetHttp
end

# Pagination
Her::Collection.include HerExt::Collection
# Some usefult methods: limit, order
Her::Model::Relation.include HerExt::Relation
