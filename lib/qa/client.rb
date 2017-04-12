class JsonApiParser < Faraday::Middleware
  def call(request_env)
    @app.call(request_env).on_complete do |response_env|
      if response_env.status == 404
        response_env.body = { data: nil }
      else
        @included = response_env.body['included']

        response_env.body = {
          data: transform(response_env.body['data']),
          meta: response_env.body['meta']
        }.with_indifferent_access
      end
    end
  end

  private

  def transform(data, included = false)
    collection = data.is_a?(Array)
    data = [data].flatten

    result = Array.new(data.size) do |i|
      entity = if included
                 @included.find do |object|
                   object['id'] == data[i]['id'] && object['type'] == data[i]['type']
                 end
               else
                 data[i]
               end

      transform_entity(entity)
    end

    collection ? result : result.first
  end

  def transform_entity(entity)
    attributes = entity['attributes']
    attributes['id'] = entity['id']

    relationships = entity['relationships']
    relationships&.each do |name, relationship|
      attributes[name] = transform(relationship['data'], true)
    end

    attributes
  end
end

class Qa::Client
  include Singleton

  class Collection
    include Enumerable

    delegate :total_pages, :total_entries, :per_page, :current_page, to: :@meta

    def initialize(response, klass)
      @collection = response.body['data'].map { |attrs| klass.new(attrs) }
      @meta = OpenStruct.new(response.body['meta'])
    end

    def each
      @collection.each { |object| yield object }
    end
  end

  class << self
    delegate :call, to: :instance
  end

  def initialize
    qa_api = Rails.application.config_for(:qa_api)

    faraday_options = {
      url: qa_api.fetch('domain'),
      headers: { 'X-Api-Version' => 'v1' }
    }

    cache_config = RedisFactory.get_config_for(:cache)
    cache_config[:namespace] = 'qa:faraday'

    cache_store = ActiveSupport::Cache::RedisStore.new(cache_config)

    @connection = Faraday.new(faraday_options) do |builder|
      # Request
      builder.use Her::Middleware::AcceptJSON

      # Response
      builder.use JsonApiParser
      builder.use FaradayMiddleware::ParseJson

      cache_options = { shared_cache: false, store: cache_store, serializer: Marshal }
      builder.use Faraday::HttpCache, **cache_options

      # Adapter
      builder.adapter Faraday.default_adapter
    end
  end

  def call(path, klass, params = {})
    response = @connection.get(path, params)
    data = response.body['data']

    return nil unless data
    data.is_a?(Array) ? Collection.new(response, klass) : klass.new(data)
  end
end
